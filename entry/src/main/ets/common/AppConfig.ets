import Colors from "./utils/Colors"
import { LogLevel } from "./utils/Log"

export default class AppConfig {

  static baseUrl = "https://meow.lingxun.ltd"

  static statusBarColor: ResourceColor = Colors.gray100
  static defaultBgColor: ResourceColor = AppConfig.statusBarColor

  // 显示的日志级别（高于此级别的才会显示）
  static showLogLevel: LogLevel = LogLevel.ERROR

}