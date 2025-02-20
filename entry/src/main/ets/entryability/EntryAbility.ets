import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import Log from '../common/utils/Log';
import AppUtil from '../common/utils/AppUtil';

const DOMAIN = 0x0000;

async function enterImmersion(windowClass: window.Window) {
  // 获取屏幕宽高
  let windowRect = windowClass.getWindowProperties().windowRect;
  AppStorage.SetOrCreate<number>("windowWidth", windowRect.width);
  AppStorage.SetOrCreate<number>("windowHeight", windowRect.height);
  // 设置窗口布局为沉浸式布局
  await windowClass.setWindowLayoutFullScreen(true)
  await windowClass.setWindowSystemBarEnable(["status", "navigation"])
}

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    AppUtil.setContext(this.context);
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    let windowClass: window.Window = await windowStage.getMainWindow()
    // await enterImmersion(windowClass)

    // 获取状态栏和导航栏的高度
    windowClass.on("avoidAreaChange", async (options) => {
      if (options.type == window.AvoidAreaType.TYPE_SYSTEM) {
        // 获取状态栏和导航栏的高度
        AppUtil.setStatusBarHeight(options.area.topRect.height)
        AppUtil.setNavigationHeight(options.area.bottomRect.height)
        Log.info(`statusBarHeight: ${await AppUtil.getStatusBarHeight()}`)
        Log.info(`navigationHeight: ${await AppUtil.getNavigationHeight()}`)
        let windowRect = windowClass.getWindowProperties().windowRect;
        AppUtil.setWindowWidth(windowRect.width);
        AppUtil.setWindowHeight(windowRect.height);
      }
    })

    windowStage.loadContent('pages/LoginPage', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}