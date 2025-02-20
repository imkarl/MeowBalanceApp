import BalanceAccount from '../common/entitys/BalanceAccount'
import toast from '../common/ui/Toast'
import Http from '../common/utils/Http'

export class BalanceRepo {

  private static balanceAccounts: Array<BalanceAccount> | void = new Array()
  private static haveLoaded = false

  /**
   * 加载所有余额账户
   */
  static async loadAll(): Promise<Array<BalanceAccount>> {
    let balanceAccounts: Array<BalanceAccount>|void = BalanceRepo.balanceAccounts
    if (!balanceAccounts || !BalanceRepo.haveLoaded) {
      balanceAccounts = await Http.get<Array<BalanceAccount>>("/v1/account/query")
        .catch((error: object|string) => {
          if (typeof error == 'string') {
            toast(error)
          } else {
            toast("请求出错了，稍后再试吧~")
          }
        })
    }
    if (!balanceAccounts) {
      balanceAccounts = new Array()
    } else {
      BalanceRepo.balanceAccounts = balanceAccounts
      BalanceRepo.haveLoaded = true
    }
    return balanceAccounts || new Array()
  }

}
