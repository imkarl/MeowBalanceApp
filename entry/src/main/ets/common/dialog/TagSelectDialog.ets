import Tag from '../entitys/Tag';
import toast from '../ui/Toast';
import Colors from '../utils/Colors';
import Dimensions from '../utils/Dimensions';

/**
 * 标签选择弹窗
 */
@CustomDialog
export struct TagSelectDialog {

  // 弹窗标题
  @State title: string = ""

  // 弹窗顶部右侧按钮
  @State rightIcon: PixelMap | ResourceStr | DrawableDescriptor | ImageContent = ""

  // 弹窗顶部右侧按钮的点击事件
  onRightIconClick: () => void = () => {}

  // 标签列表
  @State tags: Array<Tag> = []

  // 已选标签
  @State selectedTags: Array<Tag> = []

  // 已选标签的改变事件
  onSelectChanged: (tags: Array<Tag>) => void = () => {}


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

      if (this.tags.length > 0) {
        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.tags, (tag: Tag, index) => {
            Text(tag.name)
              .backgroundColor(this.isSelected(tag) ? Colors.blue600 : Colors.gray600)
              .fontColor(Colors.white)
              .fontSize(Dimensions.content_text_size)
              .alignSelf(ItemAlign.Center)
              .textAlign(TextAlign.Center)
              .height('28vp')
              .borderRadius('14vp')
              .padding({ left: '12vp', right: '12vp' })
              .margin({ left: '4vp', right: '4vp', top: '8vp' })
              .onClick(() => {
                if (!this.isSelected(tag)) {
                  this.selectTag(tag)
                } else {
                  this.cancelSelectTag(tag)
                }
                this.onSelectChanged(this.selectedTags)
              })
          }, (item: Tag, index) => item.id)
        }
        .width(Dimensions.FULL_PARENT)
        .height('300vp')
        .padding({ top: '4vp', bottom: '12vp', left: '16vp', right: '12vp' })
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

  private isSelected(tag: Tag): boolean {
    let contains = false
    this.selectedTags.forEach((item) => {
      if (item.id == tag.id) {
        contains = true
      }
    })
    return contains
  }
  private selectTag(tag: Tag) {
    let newArray = new Array<Tag>()
    this.selectedTags.forEach((item) => {
      newArray.push(item)
    })
    newArray.push(tag)
    this.selectedTags = newArray
  }
  private cancelSelectTag(tag: Tag) {
    let newArray = new Array<Tag>()
    this.selectedTags.forEach((item) => {
      if (item.id != tag.id) {
        newArray.push(item)
      }
    })
    this.selectedTags = newArray
  }

}
