import FlowType from '../enums/FlowType'
import TransactionMethod from '../enums/TransactionMethod'
import Colors from '../utils/Colors'
import BalanceAccount from './BalanceAccount'

export default class CashFlow {
  id: string

  /**
   * 收支类型
   */
  type: FlowType

  /**
   * 所属账户
   */
  account: BalanceAccount

  /**
   * 总金额
   */
  totalAmount: number

  /**
   * 交易方式
   */
  transactionMethod: TransactionMethod

  /**
   * 标题
   */
  title: string

  /**
   * 描述
   */
  description: string

  /**
   * 关联标签ID
   */
  tagIds: Array<number>

  /**
   * 事件发生时间
   */
  eventTime: number

  /**
   * 显示日期
   */
  showDate: boolean = false
  showYear: boolean = false

  constructor(
    id: string, type: FlowType, account: BalanceAccount, totalAmount: number,
    transactionMethod: TransactionMethod, title: string, description: string, tagIds: Array<number>,
    eventTime: number
  ) {
    this.id = id;
    this.type = type;
    this.account = account;
    this.totalAmount = totalAmount;
    this.transactionMethod = transactionMethod;
    this.title = title;
    this.description = description;
    this.tagIds = tagIds;
    this.eventTime = eventTime;
  }


  static getTypeName(bean: CashFlow): string {
    if (bean.type == FlowType.EXPENSE) {
      return "支出"
    } else if (bean.type == FlowType.INCOME) {
      return "收入"
    } else if (bean.type == FlowType.BORROW) {
      if (bean.totalAmount > 0) {
        return "借款"
      } else {
        return "出借"
      }
    } else if (bean.type == FlowType.REFUND) {
      if (bean.totalAmount < 0) {
        return "还款"
      } else {
        return "收款"
      }
    } else if (bean.type == FlowType.ADJUST) {
      return "余额\n调整"
    } else {
      return "其他"
    }
  }
  static getTypeColor(bean: CashFlow): ResourceColor {
    if (bean.type == FlowType.EXPENSE) {
      return "#67d9ee"
    } else if (bean.type == FlowType.INCOME) {
      return "#e75f4c"
    } else if (bean.type == FlowType.BORROW) {
      if (bean.totalAmount > 0) {
        return "#785ce0"
      } else {
        return "#1e8dac"
      }
    } else if (bean.type == FlowType.REFUND) {
      if (bean.totalAmount < 0) {
        return "#785ce0"
      } else {
        return "#1e8dac"
      }
    } else if (bean.type == FlowType.ADJUST) {
      return "#555555"
    } else {
      return "#999999"
    }
  }
  static getTotalAmount(bean: CashFlow): string {
    let value = bean.totalAmount.toString()
    if (value.indexOf(".") >= 0) {
      value = bean.totalAmount.toFixed(2)
    }
    if (bean.totalAmount > 0) {
      return `+${value}`
    } else {
      return value
    }
  }
}