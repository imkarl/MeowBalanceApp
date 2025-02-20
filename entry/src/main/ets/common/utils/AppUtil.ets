import { bundleManager, common } from '@kit.AbilityKit';
import Settings from '../ui/Settings';
import Log from './Log';

export default class AppUtil {

  private static instance: AppUtil;
  private context?: common.UIAbilityContext;

  private constructor() {
    // 私有构造函数，防止外部实例化
  }

  private static getInstance(): AppUtil {
    if (!AppUtil.instance) {
      AppUtil.instance = new AppUtil();
    }
    return AppUtil.instance;
  }

  static setContext(ctx: common.UIAbilityContext): void {
    AppUtil.getInstance().context = ctx;
  }

  static getContext(): common.UIAbilityContext {
    return AppUtil.getInstance().context!!;
  }


  static getBundleInfo(): bundleManager.BundleInfo {
    return bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
  }

  static getApplicationInfo(): bundleManager.ApplicationInfo {
    return AppUtil.getContext().applicationInfo
  }

  private static statusBarHeight: number = 0
  static setStatusBarHeight(height: number) {
    if (height > 0) {
      AppUtil.statusBarHeight = height
      Settings.put("statusBarHeight", height)
    }
  }
  static async getStatusBarHeight(): Promise<number> {
    let height = AppUtil.statusBarHeight
    if (height <= 0) {
      height = await Settings.get<number>("statusBarHeight", 0)
      if (height > 0) {
        AppUtil.statusBarHeight = height
      }
    }
    if (height <= 0) {
      height = 123
    }
    return height
  }

  private static navigationHeight: number = 0
  static setNavigationHeight(height: number) {
    if (height > 0) {
      AppUtil.navigationHeight = height
      Settings.put("navigationHeight", height)
    }
  }
  static async getNavigationHeight(): Promise<number> {
    let height = AppUtil.navigationHeight
    if (height <= 0) {
      height = await Settings.get<number>("navigationHeight", 0)
      if (height > 0) {
        AppUtil.navigationHeight = height
      }
    }
    return height
  }

  private static windowWidth: number = 0
  static setWindowWidth(width: number) {
    if (width > 0) {
      AppUtil.windowWidth = width
      Settings.put("windowWidth", width)
    }
  }
  static async getWindowWidth(): Promise<number> {
    let width = AppUtil.windowWidth
    if (width <= 0) {
      width = await Settings.get<number>("windowWidth", 0)
      if (width > 0) {
        AppUtil.windowWidth = width
      }
    }
    return width
  }

  private static windowHeight: number = 0
  static setWindowHeight(height: number) {
    if (height > 0) {
      AppUtil.windowHeight = height
      Settings.put("windowHeight", height)
    }
  }
  static async getWindowHeight(): Promise<number> {
    let height = AppUtil.windowHeight
    if (height <= 0) {
      height = await Settings.get<number>("windowHeight", 0)
      if (height > 0) {
        AppUtil.windowHeight = height
      }
    }
    return height
  }

}
