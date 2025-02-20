import http from '@ohos.net.http'
import router from '@ohos.router'
import AppConfig from '../AppConfig'
import Settings from '../ui/Settings'
import Constants from './Constants'
import Cookies from './Cookies'
import Log from './Log'
import ResponseBean from './ResponseBean'
import UserManager from './UserManager'

function getFullUrl(url: string): string {
  let fullUrl = url
  if (!url.startsWith("http://") && !url.startsWith("https://")) {
    if (url.startsWith("/")) {
      fullUrl = AppConfig.baseUrl + url
    } else {
      fullUrl = AppConfig.baseUrl + "/" + url
    }
  }
  return fullUrl
}

export default class Http {

  static get<T>(url: string, params: object | ESObject = {}): Promise<T> {
    return new Promise<T>(async (resolve, reject) => {
      try {
        let loginToken = await UserManager.getUserToken()
        // Log.error("Http request before, loginToken: "+loginToken)
        let fullUrl = getFullUrl(url)
        Log.error("Http request: GET "+fullUrl)

        let paramsStr = ""
        if (params) {
          if (params.constructor == Map) {
            (params as Map<string, object>).forEach((value, key) => {
              paramsStr += encodeURIComponent(key) + "=" + encodeURIComponent(`${value}`) + "&"
            })
          } else {
            Object.keys(params).forEach((key) => {
              paramsStr += encodeURIComponent(key) + "=" + encodeURIComponent(params[key]) + "&"
            })
            if (paramsStr.endsWith("&")) {
              paramsStr = paramsStr.substring(0, paramsStr.length - 1)
            }
            Log.error("Http request params: " + paramsStr)
          }
        }

        if (fullUrl.indexOf("?") < 0) {
          fullUrl += "?"
        }
        if (fullUrl.endsWith("&") || fullUrl.endsWith("?")) {
          fullUrl += paramsStr
        } else {
          fullUrl += ("&"+paramsStr)
        }

        let httpRequest = http.createHttp()
        httpRequest.request(fullUrl, {
          method: http.RequestMethod.GET,
          header: {
            "Cookie": loginToken ? "UserToken="+loginToken : ""
          },
        }, (err, resp) => {
          if (err || resp.responseCode != 200) {
            // 当该请求使用完毕时，调用destroy方法主动销毁
            httpRequest.destroy()
            reject(err.message+" 请求出错了，请稍后再试~")
            return
          }

          let respStr = resp.result.toString()
          let json: ResponseBean<T> = JSON.parse(respStr)
          if (json.status != 0) {
            Log.info('Http response error: ' + respStr);
            // 当该请求使用完毕时，调用destroy方法主动销毁
            httpRequest.destroy()
            reject(json.msg)

            if (json.status == 10001) {
              router.pushUrl({ url: "pages/Login" })
            }
            return
          }

          Log.error("Http response success: " + respStr)
          resolve(json.data as T)
          // 当该请求使用完毕时，调用destroy方法主动销毁
          httpRequest.destroy()
        })
      } catch (error) {
        reject(error)
      }
    });
  }

  static async post<T>(url: string, params?: object | ESObject): Promise<T> {
    return new Promise<T>(async (resolve, reject) => {
      try {
        let loginToken = await UserManager.getUserToken()
        // Log.error("Http request before, loginToken: "+loginToken)
        let fullUrl = getFullUrl(url)
        Log.error("Http request: POST " + fullUrl)

        let paramsStr = ""
        if (params) {
          if (params.constructor == Map) {
            (params as Map<string, object>).forEach((value, key) => {
              paramsStr += encodeURIComponent(key) + "=" + encodeURIComponent(`${value}`) + "&"
            })
          } else {
            let keys = Object.keys(params);
            for (let i = 0; i < keys.length; i++) {
              let key = keys[i];
              paramsStr += encodeURIComponent(key) + "=" + encodeURIComponent(params[key]) + "&"
            }
          }
          if (paramsStr.endsWith("&")) {
            paramsStr = paramsStr.substring(0, paramsStr.length - 1)
          }
          Log.error("Http request params: " + paramsStr)
        }

        let httpRequest = http.createHttp()
        httpRequest.request(fullUrl, {
          method: http.RequestMethod.POST,
          header: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Cookie": loginToken ? "UserToken=" + loginToken : "",
          },
          extraData: paramsStr,
        }, (err, resp) => {
          if (err || resp.responseCode != 200) {
            Log.error("Http request error: " + JSON.stringify(err))
            // 当该请求使用完毕时，调用destroy方法主动销毁
            httpRequest.destroy()
            reject(err.message + " 请求出错了，请稍后再试~")
            return
          }

          let userToken = Cookies.parseCookie(resp.cookies).get("UserToken");
          if (userToken && userToken.length > 0) {
            Settings.put(Constants.LOGIN_TOKEN, userToken)
          }

          let respStr = resp.result.toString()
          let json: ResponseBean<T> = JSON.parse(respStr)
          if (json.status != 0) {
            Log.error("Http response error: " + respStr)
            // 当该请求使用完毕时，调用destroy方法主动销毁
            httpRequest.destroy()
            reject(json.msg)

            if (json.status == 10001) {
              router.pushUrl({
                url: "pages/Login"
              })
            }
            return
          }

          Log.error("Http response success: " + respStr)
          resolve(json.data as T)
          // 当该请求使用完毕时，调用destroy方法主动销毁
          httpRequest.destroy()
        })
      } catch (error) {
        reject(error)
      }
    });
  }

}