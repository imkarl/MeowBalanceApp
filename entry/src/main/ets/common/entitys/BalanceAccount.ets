import AppConfig from '../AppConfig'
import BalanceAccountType from '../enums/BalanceAccountType'

/**
 * 余额账户
 */
export default class BalanceAccount {
  id: string = ""
  type: BalanceAccountType = BalanceAccountType.Wallet
  icon: string = ""
  name: string = ""
  remark: string = ""
  money: number = 0.0

  static toSheet(account: BalanceAccount, onClick: (account: BalanceAccount) => void): SheetInfo {
    let iconUrl = ""
    if (account.icon && account.icon.length > 0) {
      iconUrl = `${AppConfig.baseUrl}${account.icon}`
    }

   return {
      icon: iconUrl,
      title: account.name,
      action: () => {
        onClick(account)
      }
    }
  }

}
