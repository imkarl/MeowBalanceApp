import AppConfig from '../../../common/AppConfig'
import Colors from '../../../common/utils/Colors'
import Dimensions from '../../../common/utils/Dimensions'
import { childController } from '../../../model/ChildController'

/**
 * 子类型选择控件
 */
@ComponentV2
export default struct SubTypeSelectView {

  @Param leftTypeName: TypeName = new TypeName()
  @Param rightTypeName: TypeName = new TypeName()

  @Param initType: number = 0
  @Local currentType: number = this.initType

  @Param onTypeChanged: (type: number) => void = () => {}

  build() {
    Row() {
      Text() {
        Span(this.leftTypeName.name)
          .fontSize(Dimensions.content_line_size)
        if (this.currentType==0) {
          Span(this.leftTypeName.description)
            .fontSize(Dimensions.little_text_size)
        }
      }
      .width('50%')
      .height('30vp')
      .border({ radius: '30vp' })
      .backgroundColor(this.currentType==0 ? Colors.blue600 : AppConfig.defaultBgColor)
      .fontColor(this.currentType==0 ? Colors.white : Colors.blue600)
      .fontSize(Dimensions.content_text_size)
      .textAlign(TextAlign.Center)
      .onClick(() => {
        this.currentType = 0
        this.onTypeChanged(this.currentType)
      })

      Text() {
        Span(this.rightTypeName.name)
          .fontSize(Dimensions.content_line_size)
        if (this.currentType==1) {
          Span(this.rightTypeName.description)
            .fontSize(Dimensions.little_text_size)
        }
      }
      .width('50%')
      .height('30vp')
      .border({ radius: '30vp' })
      .backgroundColor(this.currentType==1 ? Colors.blue600 : AppConfig.defaultBgColor)
      .fontColor(this.currentType==1 ? Colors.white : Colors.blue600)
      .fontSize(Dimensions.content_text_size)
      .textAlign(TextAlign.Center)
      .onClick(() => {
        this.currentType = 1
        this.onTypeChanged(this.currentType)
      })
    }
    .width('244vp')
    .height('34vp')
    .margin({ top: '12vp' })
    .padding({ left: '2vp', right: '2vp' })
    .border({ width: '1vp', radius: '34vp', color: Colors.blue600 })
    .alignItems(VerticalAlign.Center)
  }

}

export class TypeName {
  name: string
  description: string
  constructor(name: string = "", description: string = "") {
    this.name = name
    this.description = description
  }
}
