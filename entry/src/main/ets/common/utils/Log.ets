import hilog from '@ohos.hilog'
import util from '@ohos.util';
import AppConfig from '../AppConfig';

let TAG = "MeowBalance.Log"
let MAX_LINE_LENGTH = 900

export enum LogLevel {
  DEBUG = 3,
  INFO = 4,
  WARN = 5,
  ERROR = 6,
  FATAL = 7
}

function log(priority: LogLevel, tag: string, format: string, ...args: object[]) {
  let msg = util.format(format, args)
  if (msg.length <= MAX_LINE_LENGTH) {
    println(priority, tag, msg)
    return
  }

  // 超出目标长度，自动换行打印
  let startIndex = 0
  let endIndex = MAX_LINE_LENGTH
  while (endIndex > startIndex) {
      println(
          priority,
          tag,
          (startIndex == 0 ? "" : "\t↑↑↑↑\n") + msg.substring(startIndex, endIndex)
      )
      startIndex = endIndex
      endIndex = Math.min(msg.length, startIndex + MAX_LINE_LENGTH)
  }
}

/**
 * 打印日志的真正实现
 */
function println(priority: LogLevel, tag: string, msg: string) {
  if (priority < AppConfig.showLogLevel) {
    return
  }
  if (priority == LogLevel.DEBUG) {
    hilog.debug(0x0000, tag, msg)
  } else if (priority == LogLevel.INFO) {
    hilog.info(0x0000, tag, msg)
  } else if (priority == LogLevel.WARN) {
    hilog.warn(0x0000, tag, msg)
  } else if (priority == LogLevel.ERROR) {
    hilog.error(0x0000, tag, msg)
  } else if (priority == LogLevel.FATAL) {
    hilog.fatal(0x0000, tag, msg)
  }
}


export default class Log {

  static debug(format: string, ...args: object[]) {
    log(LogLevel.DEBUG, TAG, format, args)
  }

  static info(format: string, ...args: object[]) {
    log(LogLevel.DEBUG, TAG, format, args)
  }

  static warn(format: string, ...args: object[]) {
    log(LogLevel.DEBUG, TAG, format, args)
  }

  static error(format: string, ...args: object[]) {
    log(LogLevel.DEBUG, TAG, format, args)
  }

  static fatal(format: string, ...args: object[]) {
    log(LogLevel.FATAL, TAG, format, args)
  }

}
