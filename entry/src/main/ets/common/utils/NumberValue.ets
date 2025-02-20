
export default class NumberValue {

  first: string = ""
  second: string = ""
  operation: number = 0

  toString(): string {
    if (this.operation != 0) {
      return `${this.first}${this.operation > 0 ? '+' : '-'}${this.second}`
    } else {
      return this.first
    }
  }


  static parse(value: string): NumberValue {
    let numberValue = new NumberValue()
    let text = value.trim()
    let isFirstMinus = false
    if (text.startsWith("-")) {
      text = text.substring(1, text.length)
      isFirstMinus = true
    }
    let arr = text.split(/[-+]/)
    if (text.indexOf("-") >= 0) {
      numberValue.operation = -1
    } else if (text.indexOf("+") >= 0) {
      numberValue.operation = 1
    }
    if (arr.length > 0) {
      if (isFirstMinus) {
        numberValue.first = "-${fixNumber(arr[0])}"
      } else {
        numberValue.first = NumberValue.fixNumber(arr[0])
      }
    }
    if (arr.length > 1) {
      numberValue.second = NumberValue.fixNumber(arr[1])
    }
    return numberValue
  }

  private static fixNumber(value: string): string {
    if (value.length == 0) {
      return ""
    }
    switch (value[0]) {
      case '.': {
        return `0${value}`
      }
      case '0': {
        if (value.length > 1) {
          if (value[1] != '.') {
            if (value.startsWith("0")) {
              return value.substring(1, value.length)
            }
            return value
          }
        }
      }
    }

    if (value.indexOf(".") != value.lastIndexOf(".")) {
      if (value.startsWith(".")) {
        return value.substring(0, value.length - 1)
      }
      return value
    }
    let index = value.indexOf('.')
    if (index >= 0 && value.length - index - 1 > 2) {
      return value.substring(0, value.length - 1)
    }
    return value
  }
}
