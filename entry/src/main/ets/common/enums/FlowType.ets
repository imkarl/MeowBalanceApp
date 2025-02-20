
enum FlowType {
  /**
   * 支出
   */
  EXPENSE = "expense",

  /**
   * 收入
   */
  INCOME = "income",

  /**
   * 借入
   */
  BORROW = "borrow",

  /**
   * 借出
   */
  LEND = "lend",

  /**
   * 还款
   */
  REFUND = "refund",

  /**
   * 收款
   */
  RECEIPT = "receipt",

  /**
   * 转账
   */
  TRANSFER = "transfer",

  /**
   * 余额调整
   */
  ADJUST = "adjust",
}

export default FlowType;