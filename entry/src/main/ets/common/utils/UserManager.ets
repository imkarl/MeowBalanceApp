import UserInfo from '../entitys/UserInfo'
import Settings from '../ui/Settings'
import Constants from './Constants'
import Http from './Http'

class UserManager {

  async getUserToken(): Promise<string> {
    let loginToken = await Settings.get(Constants.LOGIN_TOKEN, "")
    return loginToken
  }

  async isLogin(): Promise<boolean> {
    let loginToken = await this.getUserToken()
    return loginToken.length > 0
  }

  async loginByAuth(): Promise<UserInfo> {
    let username = await Settings.get(Constants.USER_NAME, "")
    let passwordEncrypt = await Settings.get(Constants.CRYPTO_PASSWORD, "")
    return this.login(username, passwordEncrypt)
  }
  async login(username: string, passwordEncrypt: string): Promise<UserInfo> {
    return Http.post<UserInfo>("/v1/user/login/username", {
      "username": username,
      "password": passwordEncrypt,
    }).then(async (user: UserInfo) => {
      await Settings.put(Constants.USER_NAME, username)
      await Settings.put(Constants.CRYPTO_PASSWORD, passwordEncrypt)
      await Settings.put(Constants.LOGIN_USER_INFO, JSON.stringify(user))
      return user
    })
  }

  async logout() {
    await Settings.put(Constants.LOGIN_TOKEN, '')
  }

  async getUserInfo(): Promise<UserInfo | undefined> {
    let isLogin = await this.isLogin()
    if (!isLogin) {
      return undefined
    }

    let json = await Settings.get<string>(Constants.LOGIN_USER_INFO, '')
    if (!!json && json.length > 0) {
      return JSON.parse(json) as UserInfo
    }
    return undefined
  }

}

export default new UserManager()