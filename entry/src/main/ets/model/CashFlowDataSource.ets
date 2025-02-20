import ArrayList from '@ohos.util.ArrayList';
import CashFlow from '../common/entitys/CashFlow';
import toast from '../common/ui/Toast';
import Http from '../common/utils/Http';
import DiffUtil, { OperationType } from '../common/refreshlayout/DiffUtil';
import MonthCashFlows from '../common/entitys/MonthCashFlows';
import Dates from '../common/utils/Dates';
import CashFlowRepo from './CashFlowRepo';

let DELAY_ANIMATION_DURATION: number = 300;
let PAGE_SIZE: number = 50;

export default class CashFlowDataSource implements IDataSource {
  currentPage: number = 1
  private datas: ArrayList<MonthCashFlows> = new ArrayList()
  listeners: ArrayList<DataChangeListener> = new ArrayList()

  hasMore: boolean = false

  isRefreshing = true;
  isLoadingMore: boolean = false
  onRefreshingChanged: (isRefreshing: boolean) => void = () => {}

  private nowDate = new Date(Date.now())

  constructor(datas?: ArrayList<MonthCashFlows>|undefined) {
    if (datas) {
      this.datas = datas
    } else {
      this.datas = new ArrayList()
    }
  }

  totalCount(): number {
    return this.datas.length
  }

  getCashFlowCount(datas: ArrayList<MonthCashFlows> = this.datas): number {
    let count = 0
    datas.forEach((item) => {
      count += item.cashflows.length
    })
    return count
  }

  setData(datas: ArrayList<CashFlow>) {
    this.appendData(datas, new ArrayList<MonthCashFlows>())
  }
  addData(datas: ArrayList<CashFlow>) {
    this.appendData(datas, this.datas)
  }

  private async appendData(datas: ArrayList<CashFlow>, oldDatas: ArrayList<MonthCashFlows>) {
    let newDatas = new ArrayList<MonthCashFlows>()
    oldDatas.forEach((item) => {
      newDatas.add(item)
    })

    let lastGroup = newDatas.length > 0 ? newDatas[newDatas.length - 1] : undefined
    datas.forEach((item) => {
      let eventTime = Dates.parse(item.eventTime)
      if (!lastGroup || lastGroup.year != eventTime.getFullYear() || lastGroup.month != eventTime.getMonth() + 1) {
        let newGroup = new MonthCashFlows(eventTime.getFullYear(), eventTime.getMonth() + 1, 0, 0, 0, new Array<CashFlow>())
        newDatas.add(newGroup)
        lastGroup = newGroup
      }

      lastGroup.cashflows.push(item)
    })

    newDatas.forEach((group) => {
      group.cashflows.sort((first, second) => {
        if (first.eventTime != second.eventTime) {
          return first.eventTime < second.eventTime ? 1 : (first.eventTime == second.eventTime ? 0 : -1)
        }
        return first.id < second.id ? 1 : (first.id == second.id ? 0 : -1)
      })

      group.cashflows.forEach((item, index) => {
        // 判断是否需显示日期
        let curDate = Dates.parse(item.eventTime)
        if (index == 0) {
          item.showDate = true

        } else {
          let preDate = Dates.parse(group.cashflows[index - 1].eventTime)
          if (preDate.getDay() != curDate.getDay()) {
            item.showDate = true
          }
        }

        if (curDate.getFullYear() != this.nowDate.getFullYear()) {
          item.showYear = true
        }
      })
    })

    await this.refreshTotal(newDatas)

    // 更新月度统计
    newDatas.forEach((item) => {
      let monthCount = CashFlowRepo.getMonthCount(item.year, item.month)
      item.expense = monthCount.expense
      item.income = monthCount.income
    })

    let operations = DiffUtil.diffList(this.datas, newDatas)
    this.datas = newDatas
    operations.forEach((operation) => {
      switch (operation.type) {
        case OperationType.Add: {
          this.notifyListeners(listener => {
            listener.onDataAdd(operation.from)
          })
        }

        case OperationType.Remove: {
          this.notifyListeners(listener => {
            listener.onDataDelete(operation.from)
          })
        }

        case OperationType.Update: {
          this.notifyListeners(listener => {
            listener.onDataChange(operation.from)
          })
        }

        case OperationType.Move: {
          this.notifyListeners(listener => {
            listener.onDataMove(operation.from, operation.to)
          })
        }
      }
    })
  }

  async refreshTotal(datas: ArrayList<MonthCashFlows>) {
    let years = new Array<number>()
    datas.forEach(async (item) => {
      if (years.indexOf(item.year) < 0) {
        years.push(item.year)
      }
    })
    await CashFlowRepo.loadCounts(years)
  }

  getData(index: number): MonthCashFlows | undefined {
    if (index < 0 || index >= this.datas.length) {
      return undefined
    }
    return this.datas[index]
  }

  remove(cashFlows: MonthCashFlows): ArrayList<number> {
    let newList = new ArrayList<MonthCashFlows>()
    let deleteIndexs = new ArrayList<number>()
    this.datas.forEach((item, index) => {
      if (item.year == cashFlows.year && item.month == cashFlows.month) {
        deleteIndexs.add(index)
      } else {
        newList.add(item)
      }
    })
    this.datas = newList
    return deleteIndexs
  }

  notifyDataChanged() {
    this.notifyListeners(listener => {
      listener.onDataReloaded()
    })
  }
  private notifyListeners(callback: (listner: DataChangeListener) => void) {
    this.listeners.forEach(listener => {
      callback(listener)
    })
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    this.listeners.remove(listener)
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    this.listeners.add(listener)
  }

  loadData(page: number): Promise<number> {
    if (page <= 0) {
      page = 1
    }
    return new Promise<number>((resolve, reject) => {
      Http.get<PageResult>(
        "/v1/cashflows/list",
        { "page": page, "pageSize": PAGE_SIZE, "orderBy": "event_time", "orderType": "desc" }
      )
        .then((json) => {
          this.currentPage = page
          let list = json.list as ArrayList<CashFlow>
          if (page == 1) {
            this.setData(list)
          } else {
            this.addData(list)
          }
          resolve(list.length)
        }, (error: object) => reject(error))
    })
  }


  refresh() {
    this.nowDate = new Date(Date.now())
    CashFlowRepo.clear()
    this.isRefreshing = true;
    this.currentPage = 1;
    this.loadData(this.currentPage)
      .then((loadPageCount) => {
        if (loadPageCount >= PAGE_SIZE) {
          this.hasMore = true;
          this.currentPage++;
        } else {
          this.hasMore = false;
        }
        this.closeRefresh();
      })
      .catch((err: string | Resource) => {
        toast(err);
        this.closeRefresh();
      });
  }

  closeRefresh() {
    setTimeout(() => {
      this.isRefreshing = false
      this.onRefreshingChanged(false)
    }, DELAY_ANIMATION_DURATION);
  }

  loadmore() {
    if (this.isRefreshing || this.isLoadingMore || !this.hasMore) {
      return
    }

    this.isLoadingMore = true;
    this.loadData(this.currentPage)
      .then((loadPageCount) => {
        if (loadPageCount >= PAGE_SIZE) {
          this.currentPage++;
          this.hasMore = true;
        } else {
          this.hasMore = false;
        }
        this.isLoadingMore = false;
      })
      .catch((err: string | Resource) => {
        toast(err);
        this.isLoadingMore = false;
      })
  }

}

class PageResult {
  list: ArrayList<CashFlow> = new ArrayList<CashFlow>()
}
