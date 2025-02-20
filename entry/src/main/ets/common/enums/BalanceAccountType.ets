/**
 * 余额账户类型
 */
enum BalanceAccountType {
  /**
   * 普通账户
   */
  Wallet = "wallet",

  /**
   * 信用账户
   */
  Credit = "credit",

  /**
   * 充值账户
   */
  Recharge = "recharge",

  /**
   * 金融账户
   */
  Financial = "financial",

  /**
   * 专用账户
   */
  Special = "special",
}

export default BalanceAccountType;