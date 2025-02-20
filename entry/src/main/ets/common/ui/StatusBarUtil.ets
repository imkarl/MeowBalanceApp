import { window } from "@kit.ArkUI";
import { ConfigurationConstant } from "@kit.AbilityKit";

class StatusBarUtil {
  /**
   * 设置窗口布局为沉浸式布局
   */
  async setImmersion(window: window.Window, colorMode: ConfigurationConstant.ColorMode) {
    await window.setWindowLayoutFullScreen(true)
    await window.setWindowSystemBarEnable(["status", "navigation"])

    if (colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      // 浅色模式，设置字体为黑色
      window.setWindowSystemBarProperties({
        statusBarContentColor: '#000000'
      });
    } else { // if (colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK)
      // 深色模式，设置字体为白色
      window.setWindowSystemBarProperties({
        statusBarContentColor: '#FFFFFF'
      });
    }
  }

}

export default new StatusBarUtil()