import toast from '../ui/Toast';
import Colors from '../utils/Colors';
import Dimensions from '../utils/Dimensions';

@CustomDialog
export struct ActionSheetDialog {

  // 弹窗标题
  @State title: string = ""

  // 弹窗顶部右侧按钮
  @State rightIcon: PixelMap | ResourceStr | DrawableDescriptor | ImageContent = ""

  // 弹窗顶部右侧按钮的点击事件
  onRightIconClick: () => void = () => {}

  // 选项列表
  @State sheets: Array<SheetInfo> = []


  dialogController: CustomDialogController

  build() {
    Column() {
      Stack({ alignContent: Alignment.End }) {
        Text(this.title)
          .fontColor(Colors.black)
          .fontSize('18vp')
          .textAlign(TextAlign.Center)
          .alignSelf(ItemAlign.Center)
          .width(Dimensions.FULL_PARENT)
          .height('50vp')

        Image(this.rightIcon)
          .objectFit(ImageFit.Contain)
          .width('36vp')
          .height('36vp')
          .margin({ right: '12vp' })
          .onClick(() => {
            this.onRightIconClick()
          })
      }
      .height('50vp')

      Divider()
        .strokeWidth('1vp')
        .vertical(false)
        .color(Colors.gray300)

      if (this.sheets.length > 0) {
        List() {
          ForEach(this.sheets, (item: SheetInfo) => {
            ListItem() {
              Column() {
                Row() {
                  Image(item.icon)
                    .objectFit(ImageFit.Contain)
                    .width('24vp')
                    .height('24vp')
                    .margin({ left: '30vp' })
                  Text(item.title)
                    .fontSize(Dimensions.content_text_size)
                    .fontColor(Colors.gray900)
                    .margin({ left: '12vp' })
                }
                .width(Dimensions.FULL_PARENT)
                .height("50vp")
                .alignItems(VerticalAlign.Center)
                .stateStyles({
                  normal: { .backgroundColor(Colors.white) },
                  pressed: { .backgroundColor(Colors.gray100) },
                  focused: { .backgroundColor(Colors.gray100) },
                })
                .onClick(item.action)

                Divider()
                  .strokeWidth('1vp')
                  .vertical(false)
                  .color(Colors.gray100)
              }
            }
          })
        }
        .width(Dimensions.FULL_PARENT)
        .height(`${Math.min(Math.max(60 * this.sheets.length, 300), 300)}vp`)
        .padding({ bottom: '12vp' })
      } else {
        Text("暂无数据")
          .fontSize(Dimensions.content_text_size)
          .fontColor(Colors.gray600)
          .align(Alignment.Center)
          .textAlign(TextAlign.Center)
          .width(Dimensions.FULL_PARENT)
          .height("300vp")
      }
    }
    .backgroundColor(Color.White)
    .margin(0)
    .border({
      radius: { topLeft: '16vp', topRight: '16vp', bottomLeft: 0, bottomRight: 0 }
    })
  }

}
