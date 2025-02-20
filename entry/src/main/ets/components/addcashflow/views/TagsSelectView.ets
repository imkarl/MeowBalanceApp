import Tag from '../../../common/entitys/Tag'
import Colors from '../../../common/utils/Colors'
import Dimensions from '../../../common/utils/Dimensions'
import InputMethod from '../../../common/ui/InputMethod'
import toast from '../../../common/ui/Toast'
import FlowType from '../../../common/enums/FlowType'
import { TagSelectDialog } from '../../../common/dialog/TagSelectDialog'
import AppConfig from '../../../common/AppConfig'

/**
 * 标签选择控件
 */
@ComponentV2
export default struct TagsSelectView {

  @Param type: FlowType = FlowType.EXPENSE
  @Param initTags?: Array<Tag> = undefined
  @Local selectedTags: Array<Tag> = new Array()

  @Param onSelectChanged: (tags: Array<Tag>) => void = () => {}

  aboutToAppear(): void {
    if (this.initTags && this.initTags.length > 0) {
      this.selectedTags = this.initTags
    }
  }

  build() {
    Row() {
      Image($r('app.media.ic_tag'))
        .width('16vp')
        .height('34vp')
        .objectFit(ImageFit.Contain)
        .align(Alignment.Center)

      Text("标签：")
        .height('34vp')
        .fontColor(Colors.gray800)
        .fontSize(Dimensions.content_text_size)
        .margin({ left: '4vp' })

      Column() {
        if (this.selectedTags.length > 0) {
          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(this.selectedTags, (item: Tag, index) => {
              Text(item.name)
                .backgroundColor(Colors.blue600)
                .fontColor(Colors.white)
                .fontSize(Dimensions.little_text_size)
                .alignSelf(ItemAlign.Center)
                .textAlign(TextAlign.Center)
                .height('20vp')
                .borderRadius('10vp')
                .padding({ left: '8vp', right: '8vp' })
                .margin({ left: '2vp', right: '2vp', top: '4vp' })
            }, (item: Tag, index) => item.id)
          }
          .padding({ top: '3vp', bottom: '7vp' })
          .width("100%")
        } else {
          Text("请选择标签...")
            .fontColor(Colors.gray600)
            .fontSize(Dimensions.content_text_size)
            .alignSelf(ItemAlign.Start)
            .textAlign(TextAlign.Start)
            .height('34vp')
        }

        Divider()
          .strokeWidth('1vp')
          .vertical(false)
          .color(Colors.gray600)
      }
      .width('50%')
      .flexGrow(1)
      .margin({ left: '8vp' })
      .stateStyles({
        normal: { .backgroundColor(AppConfig.defaultBgColor) },
        pressed: { .backgroundColor(Colors.gray200) },
        focused: { .backgroundColor(Colors.gray200) },
      })
      .onClick(() => {
        this.onClickSelect()
      })
    }
    .width(Dimensions.FULL_PARENT)
    .flexGrow(1)
    .padding({ left: '24vp', right: '24vp' })
    .margin({ top: '12vp' })
    .alignItems(VerticalAlign.Top)
  }

  private async onClickSelect() {
    let tags = await Tag.loadAll(this.type)
    this.showBottomDialog(
      "选择标签",
      tags,
      this.selectedTags,
      () => {
        toast("setting")
      },
      (selectedTags) => {
        this.selectedTags = selectedTags;
        this.onSelectChanged(selectedTags);
      }
    )
  }


  private dialog?: CustomDialogController = undefined
  /**
   * 显示底部弹窗
   */
  private showBottomDialog(
    title: string,
    allTags: Array<Tag>,
    selectedTags: Array<Tag>,
    onRightIconClick: () => void,
    onSelectChanged: (tags: Array<Tag>) => void
  ) {
    InputMethod.hideSoftKeyboard()

    if (this.dialog != undefined) {
      this.dialog?.close()
    }
    this.dialog = new CustomDialogController({
      builder: TagSelectDialog({
        title: title,
        rightIcon: $r('app.media.ic_topnav_settings'),
        onRightIconClick: onRightIconClick,
        tags: allTags,
        selectedTags: selectedTags,
        onSelectChanged: onSelectChanged,
      }),
      alignment: DialogAlignment.Bottom,
      offset: { dx: 0, dy: 0 },
      customStyle: true,
      autoCancel: true,
      cancel: () => {
        this.dialog = undefined
      }
    })
    this.dialog.open()
  }

}