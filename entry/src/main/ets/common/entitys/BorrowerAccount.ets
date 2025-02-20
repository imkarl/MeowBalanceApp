import BorrowerAccountType from '../enums/BorrowerAccountType'
import toast from '../ui/Toast'
import Http from '../utils/Http'

/**
 * 借贷账户
 */
export default class BorrowerAccount {
  id: string = ""
  type: BorrowerAccountType = BorrowerAccountType.CREDIT
  name: string = ""
  remark: string = ""
  money: number = 0.0

  static toSheet(account: BorrowerAccount, onClick: (account: BorrowerAccount) => void): SheetInfo {
   return {
      title: account.name,
      action: () => {
        onClick(account)
      }
    }
  }


  private static balanceAccounts: Array<BorrowerAccount> | undefined = new Array()
  private static haveLoaded = false

  static clearCache() {
    BorrowerAccount.balanceAccounts = undefined
    BorrowerAccount.haveLoaded = false
  }

  /**
   * 加载所有借贷账户
   */
  static async loadAll(): Promise<Array<BorrowerAccount>> {
    let balanceAccounts: Array<BorrowerAccount>|undefined = BorrowerAccount.balanceAccounts
    if (!balanceAccounts || !BorrowerAccount.haveLoaded) {
      balanceAccounts = await Http.get<Array<BorrowerAccount>>("/v1/borrower/query")
        .catch((error: object|string) => {
          if (typeof error == 'string') {
            toast(error)
          } else {
            toast("请求出错了，稍后再试吧~")
          }
          return undefined
        })
    }
    if (!balanceAccounts) {
      balanceAccounts = new Array()
    } else {
      BorrowerAccount.balanceAccounts = balanceAccounts
      BorrowerAccount.haveLoaded = true
    }
    return balanceAccounts || new Array()
  }

  /**
   * 加载所有借贷账户
   */
  static async load(type: BorrowerAccountType): Promise<Array<BorrowerAccount>> {
    let all = await BorrowerAccount.loadAll()
    return all.filter((item) => { item.type == type })
  }
}
