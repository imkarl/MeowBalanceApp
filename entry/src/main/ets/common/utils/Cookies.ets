import { ArrayList } from '@kit.ArkTS';

class Cookie {
  name: string;
  value: string;
  expires: Date | undefined;

  constructor(name: string, value: string, expires?: Date) {
    this.name = name;
    this.value = value;
    this.expires = expires; // 如果没有指定过期时间，则设置为当前时间
  }
}

class Cookies {
  cookies: ArrayList<Cookie> = new ArrayList()

  constructor(cookies: Array<Cookie | undefined>) {
    cookies.forEach((cookie) => {
      if (cookie != undefined) {
        this.cookies.add(cookie);
      }
    })
  }

  get(name: string): string {
    let value = ""
    this.cookies.forEach((cookie) => {
      if (cookie.name.toLowerCase() == name.toLowerCase()) {
        value = cookie.value
      }
    })
    return value.trim()
  }

  static parseCookie(cookieString: string): Cookies {
    const parts = cookieString.split('; ');
    const cookies = parts.map((part) => {
      // 192.168.3.138	FALSE	/	FALSE	0	UserToken	zBVp0NZaag3lp-muD1MSW
      const nameValue = part.split('\t');
      const name = nameValue[nameValue.length - 2];
      const value = nameValue[nameValue.length - 1];
      if (!name || name.length == 0 || !value || value.length == 0) {
        return undefined
      }

      // 解析expires属性
      let dateStr = nameValue[nameValue.length - 3];
      let expires: Date | undefined
      if (dateStr || dateStr == '0') {
        expires = undefined; // 默认过期时间为当前时间
      } else {
        expires = new Date(dateStr);
      }

      return new Cookie(name, value, expires);
    })

    return new Cookies(cookies);
  }
}

export default Cookies
