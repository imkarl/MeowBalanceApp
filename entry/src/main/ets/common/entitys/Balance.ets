/**
 * 余额
 */
export default class Balance {
  /**
   * 现金
   */
  fiatMoney: number = 0

  /**
   * 资产
   */
  financialMoney: number = 0

  /**
   * 债权（借出/贷出，仅现金）
   */
  lendingMoney: number = 0

  /**
   * 负债（借入/贷入，仅现金）
   */
  borrowingMoney: number = 0

  constructor(balance?: Balance) {
    if (!!balance) {
      this.fiatMoney = balance.fiatMoney
      this.financialMoney = balance.financialMoney
      this.lendingMoney = balance.lendingMoney
      this.borrowingMoney = balance.borrowingMoney
    }
  }

  /**
   * 个人净资产
   * @returns 个人净资产 = 现金 + 资产 + 债权 - 负债
   */
  calculateNetAssets(): number {
    return this.fiatMoney + this.financialMoney + this.lendingMoney - this.borrowingMoney
  }

  /**
   * 总资产
   * @returns 总资产 = 现金 + 资产 + 债权
   */
  calculateTotalAssets(): number {
    return this.fiatMoney + this.financialMoney + this.lendingMoney
  }

}
