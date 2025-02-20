import Http from '../common/utils/Http';
import HashMap from '@ohos.util.HashMap';
import Log from '../common/utils/Log';

class CashFlowRepo {

  private yearCounts: HashMap<number, YearCountResult> = new HashMap()

  clear() {
    this.yearCounts.clear()
  }

  loadCounts(years: Array<number>): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      this.loadAllYearCounts(years, 0, () => {
        resolve()
      })
    })
  }
  private loadAllYearCounts(years: Array<number>, index: number, onLoadEnd: () => void) {
    if (years.length > 0 && index < years.length) {
      this.loadYearCount(years[index])
        .then(() => { this.loadAllYearCounts(years, index + 1, onLoadEnd) })
    } else {
      onLoadEnd()
    }
  }

  private loadYearCount(year: number): Promise<void> {
    if (year < 2000 || year >= 9999) {
      // 无效的年份
      return Promise.resolve()
    }
    return Http.get<YearCountResult>(`/v1/cashflows/count/${year}`)
      .then((yearCountResult) => {
        this.yearCounts.set(year, new YearCountResult(yearCountResult))
      })
      .catch(() => {})
  }

  getYearCount(year: number): YearCountResult {
    let yearCount = this.yearCounts.get(year)
    if (!yearCount || yearCount == undefined) {
      this.loadYearCount(year)
      yearCount = new YearCountResult()
    }
    return yearCount
  }

  getMonthCount(year: number, month: number): MonthCountResult {
    let yearCount = this.getYearCount(year)
    let monthCount = new MonthCountResult()
    yearCount.parts.forEach((monthCountResult) => {
      if (monthCountResult.month == month) {
        monthCount = monthCountResult
      }
    })
    return monthCount
  }

  /**
   * 获取最近12个月的收支统计
   */
  getLast12MonthCount(): Array<MonthCountResult> {
    let now = new Date(Date.now())

    let last12MonthCounts: Array<MonthCountResult> = new Array()

    // 当前不是12月
    if (now.getMonth() + 1 != 12) {
      // 获取去年的月份
      let preYearCount = this.getYearCount(now.getFullYear() - 1)
      for (let month = now.getMonth() + 2; month <= 12; month++) {
        const monthCount = preYearCount.parts.find((item) => item.month == month)
        last12MonthCounts.push(monthCount || new MonthCountResult(month))
      }
    }

    let nowYearCount = this.getYearCount(now.getFullYear())
    for (let month = 1; month <= now.getMonth() + 1; month++) {
      const monthCount = nowYearCount.parts.find((item) => item.month == month)
      last12MonthCounts.push(monthCount || new MonthCountResult(month))
    }
    return last12MonthCounts
  }

  getMaxMoney(monthCounts: Array<MonthCountResult>): number {
    let max = 0
    monthCounts.forEach((item) => {
      max = Math.max(Math.max(Math.abs(item.expense), item.income), max)
    })
    return Math.max(max, 100)
  }

}

export class YearCountResult {
  expense: number = 0
  income: number = 0
  parts: Array<MonthCountResult> = new Array()

  constructor(
    count?: YearCountResult
  ) {
    if (!!count) {
      this.expense = count.expense
      this.income = count.income
      this.parts = count.parts
    }
  }
}
export class MonthCountResult {
  expense: number = 0
  income: number = 0
  month: number = 0

  constructor(month: number = 0) {
    this.month = month
  }
}

export default new CashFlowRepo()
