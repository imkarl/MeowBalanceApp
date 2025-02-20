import Colors from '../common/utils/Colors';
import Dimensions from '../common/utils/Dimensions';
import PromptUtil from '../common/ui/PromptUtil';
import Constants from '../common/utils/Constants';
import AppConfig from '../common/AppConfig';
import Settings from '../common/ui/Settings';
import RSA from '../common/utils/RSA';
import InputMethod from '../common/ui/InputMethod';
import Http from '../common/utils/Http';
import { toastError } from '../common/ui/Toast';

@Extend(TextInput)
function inputStyle() {
  .backgroundColor(Colors.white)
  .placeholderColor(Colors.gray)
  .fontColor(Colors.black)
  .passwordIcon({
    onIconSrc: $r('app.media.eye'),
    offIconSrc: $r("app.media.eye_off")
  })
  .height('48vp')
  .fontSize('12vp')
  .width(Dimensions.FULL_PARENT)
  .padding({ left: 0 })
  .margin({ top: '12vp' })
}

@Extend(Line)
function lineStyle() {
  .width(Dimensions.FULL_PARENT)
  .height('1vp')
  .backgroundColor(Colors.line_color)
}

@Component
export struct RegisterPage {
  @State isShowFace: boolean = false;
  @State isShowFingerprint: boolean = false;
  @State isRegisterAvailable: boolean = false;
  @Consume('pageInfos') pageInfos: NavPathStack;
  private username: string = '';
  private password: string = '';
  private confirmPassWord: string = '';
  @Consume('isFace') isFace : boolean;
  @Consume('isFingerprint') isFingerprint: boolean;

  /**
   * Check whether the registration button can be clicked.
   */
  isRegister() {
    this.isRegisterAvailable = false;
    if (this.username.length > 0 && this.password.length > 0 && this.confirmPassWord.length > 0) {
      this.isRegisterAvailable = true;
    }
  }

  /**
   * Process the registration process.
   */
  async doRegister() {
    InputMethod.hideSoftKeyboard()

    if (this.username === '' || this.username.trim().length == 0) {
      PromptUtil.promptMessage('请输入用户名');
      return;
    }
    if (this.password === '' || this.password.trim().length == 0) {
      PromptUtil.promptMessage('请输入密码');
      return;
    }
    if (this.password !== this.confirmPassWord) {
      PromptUtil.promptMessage('输入的密码不相同，请重新输入');
      return;
    }

    let passwordEncrypt = await RSA.encrypt(this.password);
    Http.post<void>("/v1/user/register/username", {
      "username": this.username,
      "password": passwordEncrypt,
    }).then((_: void) => {
      Settings.put(Constants.CRYPTO_PASSWORD, passwordEncrypt);
      Settings.put(Constants.USER_NAME, this.username);
      Settings.put(Constants.IS_SHOW_FACE, this.isFace);
      Settings.put(Constants.IS_SHOW_FINGERPRINT, this.isFingerprint);

      this.pageInfos.pop()
    }).catch((error: object) => {
      toastError(error)
    })
  }

  build() {
    NavDestination() {
      Row() {
        Column() {
          Image($r('app.media.startIcon'))
            .width('78vp')
            .height('78vp')
            .margin({
              top: '80vp',
              bottom: '8vp'
            })
          Text('注册')
            .fontSize(Dimensions.title_text_size)
            .fontWeight(FontWeight.Medium)
            .fontColor(Colors.title_text_color)

          Column() {
            TextInput({ placeholder: '请输入用户名'})
              .maxLength(Constants.INPUT_ACCOUNT_LENGTH)
              .type(InputType.USER_NAME)
              .inputStyle()
              .onChange((value: string) => {
                this.username = value;
                this.isRegister();
              })

            Line().lineStyle()

            TextInput({ placeholder: '请输入密码'})
              .maxLength(Constants.INPUT_PASSWORD_LENGTH)
              .type(InputType.NEW_PASSWORD)
              .inputStyle()
              .onChange((value: string) => {
                this.password = value;
                this.isRegister();
              })

            Line().lineStyle()

            TextInput({ placeholder: '请再次输入密码'})
              .maxLength(Constants.INPUT_PASSWORD_LENGTH)
              .type(InputType.NEW_PASSWORD)
              .inputStyle()
              .onChange((value: string) => {
                this.confirmPassWord = value;
                this.isRegister();
              })
          }
          .backgroundColor(Colors.white)
          .borderRadius(Dimensions.inputBorderRadius)
          .padding({
            top: '4vp',
            bottom: '4vp',
            left: '12vp',
            right: '12vp'
          })
          .margin({
            top: '28vp'
          })

          if (this.isShowFace) {
            Row() {
              Checkbox()
                .select(this.isFace)
                .selectedColor(Colors.blue600)
                .onChange((value: boolean) => {
                  this.isFace = value;
                })
              Text('人脸识别登录')
                .fontSize('16vp')
                .fontWeight(FontWeight.Medium)
                .fontColor(Colors.black)
                .onClick(async () => {
                  this.isFace = !this.isFace
                })
            }
            .width(Dimensions.FULL_PARENT)
            .margin({
              top: '14vp',
              left: '24vp'
            })
          }

          if (this.isShowFingerprint) {
            Row() {
              Checkbox()
                .selectedColor(Colors.blue600)
                .select(this.isFingerprint)
                .onChange((value: boolean) => {
                  this.isFingerprint = value;
                })
              Text('指纹识别登录')
                .fontSize('16vp')
                .fontWeight(FontWeight.Medium)
                .fontColor(Colors.black)
                .onClick(async () => {
                  this.isFingerprint = !this.isFingerprint
                })
            }
            .width(Dimensions.FULL_PARENT)
            .margin({
              top: '14vp',
              left: '24vp'
            })
          }

          Button('注册', { type: ButtonType.Capsule })
            .width(Constants.BUTTON_WIDTH)
            .height('40vp')
            .fontSize(Dimensions.normal_text_size)
            .fontWeight(FontWeight.Medium)
            .backgroundColor(
              this.isRegisterAvailable ? '#0A59F7' : '#66007DFF'
            )
            .margin({
              top: '58vp',
              bottom: '12vp'
            })
            .enabled(this.isRegisterAvailable)
            .onClick(async () => {
              await this.doRegister();
            })
        }
        .backgroundColor(AppConfig.defaultBgColor)
        .height(Dimensions.FULL_PARENT)
        .width(Dimensions.FULL_PARENT)
        .padding({
          left: '12vp',
          right: '12vp',
          bottom: '24vp'
        })
      }
      .height(Dimensions.FULL_PARENT)
    }
    .hideTitleBar(true)
    .onAppear(async () => {
      // this.isShowFace = UserAuthModel.isFaceAvailable();
      // this.isShowFingerprint = UserAuthModel.isFingerprintAvailable();
      // this.isFace = await Settings.get(Constants.IS_SHOW_FACE, false);
      // this.isFingerprint = await Settings.get(Constants.IS_SHOW_FINGERPRINT, false);
    })
  }
}
