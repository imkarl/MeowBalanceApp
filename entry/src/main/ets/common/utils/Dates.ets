import { intl } from '@kit.LocalizationKit';

class Dates {

  parse(date: Date | number): Date {
    if (typeof date == 'number') {
      date = new Date(date)
    }

    return date
  }

  format(date: Date | number, format: string = 'yyyy年MM月dd日'): string {
    date = this.parse(date)
    return format.replace('yyyy', date.getFullYear().toString())

      .replace('MM', ('0' + (date.getMonth() + 1)).slice(-2))
      .replace('M', (date.getMonth() + 1).toString())

      .replace('dd', ('0' + date.getDate()).slice(-2))
      .replace('d', date.getDate().toString())
  }

  toMilliseconds(date: Date | number): number {
    let milliseconds = 0
    if (typeof date == 'number') {
      milliseconds = date
    } else if (typeof date === 'object' && date instanceof Date) {
      milliseconds = date.getTime()
    }
    return milliseconds
  }

}

export default new Dates();