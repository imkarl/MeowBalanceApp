/**
 * 借贷账户类型
 */
enum BorrowerAccountType {
  /**
   * 出借方（可以从该账户借入）
   */
  DEBIT = "DEBIT",

  /**
   * 贷方（可以借出给该账户）
   */
  CREDIT = "CREDIT",
}

export default BorrowerAccountType;