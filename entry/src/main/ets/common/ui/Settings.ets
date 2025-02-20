import preferences from '@ohos.data.preferences';
import AppUtil from '../utils/AppUtil';

let preferenceName = "app_settings"

type ValueType = number | string | boolean | Array<number> | Array<string> | Array<boolean>;


export default class Settings {

  static async get<T extends ValueType>(key: string, defaultValue: T): Promise<T> {
    return new Promise<T>((resolve, reject) => {
      try {
        try {
          let value = AppStorage.get<object>(key)
          if (value) {
            resolve(value as T)
            return
          }
        } catch (error) {
        }

        let context = AppUtil.getContext()

        preferences.getPreferences(context, preferenceName)
          .then(pref => {
            pref.get(key, defaultValue)
              .then((value) => {
                resolve(value as T);
              })
              .catch((error: object) => {
                reject(error);
              });
          })
          .catch((error: object) => {
            reject(error);
          });
      } catch (err) {
        console.error("Failed to get preferences. code =" + err.code + ", message =" + err.message);
        reject(err);
      }
    });
  }

  static async put(key: string, value: ValueType): Promise<void> {
    return new Promise<void>((resolve, reject) => {
      try {
        PersistentStorage.PersistProp(key, value)

        let context = AppUtil.getContext()

        preferences.getPreferences(context, preferenceName)
          .then(pref => {
            pref.put(key, value)
              .then(() => {
                resolve();
              })
              .catch((error: object) => {
                reject(error);
              });;
            pref.flush()
          })
          .catch((error: object) => {
            reject(error);
          });;
      } catch (err) {
        console.error("Failed to get preferences. code =" + err.code + ", message =" + err.message);
        reject(err);
      }
    });
  }

}
