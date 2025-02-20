import InputMethod from '../common/ui/InputMethod';
import { toastError } from '../common/ui/Toast';
import Colors from '../common/utils/Colors';
import { router, window } from '@kit.ArkUI';
import { RegisterPage } from '../components/RegisterPage';
import Dimensions from '../common/utils/Dimensions';
import Constants from '../common/utils/Constants';
import PromptUtil from '../common/ui/PromptUtil';
import AppConfig from '../common/AppConfig';
import UserAuthModel from '../model/UserAuthModel';
import RSA from '../common/utils/RSA';
import UserInfo from '../common/entitys/UserInfo';
import UserManager from '../common/utils/UserManager';
import StatusBarUtil from '../common/ui/StatusBarUtil';
import { ConfigurationConstant } from '@kit.AbilityKit';

@Extend(TextInput)
function inputStyle() {
  .placeholderColor(Colors.placeholder_color)
  .height(Dimensions.inputHeight)
  .passwordIcon({
    onIconSrc: $r('app.media.eye'),
    offIconSrc: $r("app.media.eye_off")
  })
  .fontSize('18vp')
  .fontColor(Colors.black)
  .backgroundColor(Color.White)
  .width(Dimensions.FULL_PARENT)
  .padding({ left: Dimensions.input_padding_left })
  .margin({ top: Dimensions.input_margin_top })
  .textAlign(TextAlign.Start)
}

@Extend(Line)
function lineStyle() {
  .width(Dimensions.FULL_PARENT)
  .height(Dimensions.line_height)
  .backgroundColor(Colors.line_color)
}

@Extend(Text)
function blueTextStyle() {
  .fontColor(Colors.blue600)
  .fontSize(Dimensions.small_text_size)
  .fontWeight(FontWeight.Medium)
}

/**
 * Login Page.
 */
@Entry
@Component
struct LoginPage {
  @State username: string = ""
  @State password: string = ""

  @Provide('isFace') isFace: boolean = false;
  @Provide('isFingerprint') isFingerprint: boolean = false;
  @State isLoginCanClick: boolean = false;
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();

  async aboutToAppear() {
    let isLogin = await UserManager.isLogin();
    if (isLogin) {
      router.replaceUrl({ url: "pages/MainPage" })
      return
    }
    let win = await window.getLastWindow(getContext(this))
    StatusBarUtil.setImmersion(win, ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
  }

  async onPageShow() {
    window.getLastWindow(getContext(this)).then((windowStage: window.Window) => {
      windowStage.setWindowPrivacyMode(true);
    });
    // this.isFace = await Settings.get<boolean>(Constants.IS_SHOW_FACE, false);
    // this.isFingerprint = await Settings.get<boolean>(Constants.IS_SHOW_FINGERPRINT, false);
  }

  onPageHide(): void {
    window.getLastWindow(getContext(this)).then((windowStage: window.Window) => {
      windowStage.setWindowPrivacyMode(false);
    });
  }

  @Builder
  PagesMap(name: string) {
    if (name === 'register') {
      RegisterPage()
    }
  }

  /**
   * Check whether the login button can be clicked
   */
  isLoginClickAvailable() {
    this.isLoginCanClick = false;
    if (this.username.length > 0 && this.password.length > 0) {
      this.isLoginCanClick = true;
    }
  }

  /**
   * Operations After a User Is Successfully Authenticated.
   *
   * @param Whether the user authentication is successful.
   */
  userAuthResult: (isSuccess: boolean) => void = (isSuccess: boolean) => {
    if (isSuccess) {
      UserManager.loginByAuth()
        .then(() => {
          router.replaceUrl({ url: 'pages/MainPage' });
        })
        .catch((error: object) => {
          toastError(error);
        })
    }
  }

  build() {
    Navigation(this.pageInfos) {
      Column() {
        Image($r('app.media.startIcon'))
          .width('78vp')
          .height('78vp')
          .margin({
            top: '80vp',
            bottom: '8vp'
          })
        Text('登录')
          .fontSize(Dimensions.title_text_size)
          .fontWeight(FontWeight.Medium)
          .fontColor(Colors.title_text_color)
        Text('登录账号以使用更多服务')
          .fontSize(Dimensions.normal_text_size)
          .fontColor(Colors.login_tips_text_color)
          .margin({
            top: '8vp',
            bottom: '28vp'
          })

        Column() {
          TextInput({ placeholder: '账号', text: this.username })
            .maxLength(Constants.INPUT_ACCOUNT_LENGTH)
            .type(InputType.USER_NAME)
            .inputStyle()
            .onChange((value: string) => {
              this.username = value;
              this.isLoginClickAvailable();
            })

          Line().lineStyle()

          TextInput({ placeholder: '密码' })
            .maxLength(Constants.INPUT_PASSWORD_LENGTH)
            .type(InputType.Password)
            .inputStyle()
            .onChange((value: string) => {
              this.password = value;
              this.isLoginClickAvailable();
            })
        }
        .backgroundColor(Color.White)
        .borderRadius(Dimensions.inputBorderRadius)
        .padding({
          top: Dimensions.input_padding_top,
          bottom: Dimensions.input_padding_top,
          left: Dimensions.input_padding_left,
          right: Dimensions.input_padding_left
        })

        Row() {
          Text('短信验证码登录').blueTextStyle()
          Text('忘记密码').blueTextStyle()
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width(Dimensions.FULL_PARENT)
        .padding({
          top: '12vp',
          left: '24vp',
          right: '12vp'
        })

        Button("登录", { type: ButtonType.Capsule })
          .width(Constants.BUTTON_WIDTH)
          .height('40vp')
          .fontSize(Dimensions.normal_text_size)
          .fontWeight(FontWeight.Medium)
          .backgroundColor(this.isLoginCanClick ? '#0A59F7' : '#66007DFF')
          .margin({
            top: '58vp',
            bottom: '12vp'
          })
          .onClick(() => {
            this.login();
          })
        Text("注册账号")
          .fontColor(Colors.blue600)
          .fontSize(Dimensions.normal_text_size)
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            this.pageInfos.pushPathByName('register', null);
          })

        Blank()

        if (this.isFace || this.isFingerprint) {
          Text("其他登录方式")
            .fontColor(Colors.gray)
            .fontSize(Dimensions.little_text_size)
            .fontWeight(FontWeight.Medium)
            .margin({
              top: '50vp',
              bottom: '12vp'
            })
          Row({ space: Constants.LOGIN_METHODS_SPACE }) {
            if (this.isFace) {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image($r('app.media.face'))
              }
              .height('48vp')
              .width('48vp')
              .backgroundColor(AppConfig.defaultBgColor)
              .onClick(() => {
                UserAuthModel.getFaceAuth(this.userAuthResult);
                UserAuthModel.start();
              })
            }

            if (this.isFingerprint) {
              Button({ type: ButtonType.Circle, stateEffect: true }) {
                Image($r('app.media.touchid'))
              }
              .height('48vp')
              .width('48vp')
              .backgroundColor(AppConfig.defaultBgColor)
              .onClick(() => {
                UserAuthModel.getFingerprintAuth(this.userAuthResult);
                UserAuthModel.start();
              })
            }
          }
        }
      }
      .backgroundColor(AppConfig.defaultBgColor)
      .height(Dimensions.FULL_PARENT)
      .width(Dimensions.FULL_PARENT)
      .padding({
        left: '12vp',
        right: '12vp',
        bottom: '12vp'
      })
    }
    .navDestination(this.PagesMap)
    .hideTitleBar(true)
    .hideToolBar(true)
    .mode(NavigationMode.Stack)
    .backgroundColor(AppConfig.defaultBgColor)
  }

  async login() {
    InputMethod.hideSoftKeyboard()

    if (this.username === '' || this.username.trim().length == 0) {
      PromptUtil.promptMessage('账号不能为空');
      return;
    }
    if (this.password === '' || this.password.trim().length == 0) {
      PromptUtil.promptMessage('密码不能为空');
      return;
    }

    let passwordEncrypt = await RSA.encrypt(this.password);
    UserManager.login(this.username, passwordEncrypt)
      .then((user: UserInfo) => {
        router.replaceUrl({ url: "pages/MainPage" })
      }).catch((error: object) => {
        toastError(error)
      })
  }

}
