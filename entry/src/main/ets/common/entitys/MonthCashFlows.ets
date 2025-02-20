import CashFlow from './CashFlow'

export default class MonthCashFlows {
  // 当前年份
  year: number
  // 当前月份
  month: number

  // 月度总支出
  expense: number
  // 月度总收入
  income: number
  // 月度总借出和还款
  borrowOut: number

  cashflows: Array<CashFlow>

  constructor(
    year: number,
    month: number,
    expense: number,
    income: number,
    borrowOut: number,
    cashflows: Array<CashFlow>,
  ) {
    this.year = year;
    this.month = month;
    this.expense = expense;
    this.income = income;
    this.borrowOut = borrowOut;
    this.cashflows = cashflows;
  }

}