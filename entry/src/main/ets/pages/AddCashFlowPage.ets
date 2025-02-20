import { common, ConfigurationConstant } from '@kit.AbilityKit'
import { router, window } from '@kit.ArkUI'
import StatusBarUtil from '../common/ui/StatusBarUtil'
import FlowType from '../common/enums/FlowType'
import { InputMoneyDialogBuilder } from '../common/dialog/InputMoneyDialog'
import Http from '../common/utils/Http'
import toast, { toastError } from '../common/ui/Toast'
import AppUtil from '../common/utils/AppUtil'
import AppConfig from '../common/AppConfig'
import Colors from '../common/utils/Colors'
import Dimensions from '../common/utils/Dimensions'
import BorrowOrLendView from '../components/addcashflow/BorrowOrLendView'
import ExpenseView from '../components/addcashflow/ExpenseView'
import IncomeView from '../components/addcashflow/IncomeView'
import RefundOrReceiptView from '../components/addcashflow/RefundOrReceiptView'
import TransferView from '../components/addcashflow/TransferView'
import AdjustView from '../components/addcashflow/AdjustView'
import { childController } from '../model/ChildController'
import { HashMap } from '@kit.ArkTS'

@Extend(Text)
function textStyleByFlowType(selected: boolean) {
  .fontColor(selected ? Colors.black : Colors.gray900)
  .fontSize(selected ? Dimensions.topnav_text_size : Dimensions.small_text_size)
  .fontWeight(selected ? FontWeight.Regular : FontWeight.Normal)
  .padding({ left: '10vp', right: '10vp' })
  .height('40vp')
}

@Entry
@Component
struct AddCashFlowPage {
  context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext
  private statusBarHeight: number = 0
  private controller: TabsController = new TabsController();
  private tabArrays: Array<string> = ["支出", "收入", "借贷", "还债", "转账", "余额调整"]

  private getFlowType(tabIndex: number): FlowType {
    let flowType: FlowType = FlowType.EXPENSE
    switch (this.tabArrays[tabIndex]) {
      case "支出":
        flowType = FlowType.EXPENSE
        break

      case "收入":
        flowType = FlowType.INCOME
        break

      case "借贷":
        flowType = FlowType.BORROW
        break

      case "还债":
        flowType = FlowType.REFUND
        break

      case "转账":
        flowType = FlowType.TRANSFER
        break

      case "余额调整":
        flowType = FlowType.ADJUST
        break
    }

    return flowType
  }

  @State type: FlowType = FlowType.EXPENSE
  @State subType?: FlowType = undefined
  private params: HashMap<FlowType, object> = new HashMap()

  async aboutToAppear() {
    this.statusBarHeight = await AppUtil.getStatusBarHeight()

    let win = await window.getLastWindow(getContext(this))
    StatusBarUtil.setImmersion(win, ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT)
  }

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: 300 })
      .slide(SlideEffect.Bottom)
      .opacity(0.1)
    PageTransitionExit({ type: RouteType.None, duration: 300 })
      .slide(SlideEffect.Bottom)
      .opacity(0.1)
  }

  build() {
    Column() {
      Row() {
        Row() {
          Image($r("app.media.ic_topnav_back"))
            .width('24vp')
            .height('24vp')
          Text("记一笔")
            .fontColor(Colors.black)
            .fontSize(Dimensions.topnav_text_size)
        }
        .height('50vp')
        .onClick(() => {
          router.back()
        })

        Row().flexGrow(1)

        Text("完成")
          .fontColor(Colors.blue800)
          .fontSize(Dimensions.topnav_text_size)
          .width("56vp")
          .height('50vp')
          .onClick(() => {
            this.doSubmit()
          })
      }
      .width("100%")
      .height('50vp')

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.tabArrays, (item: string, index: number) => {
          Text(item)
            .textStyleByFlowType(this.type == this.getFlowType(index))
            .onClick(() => {
              this.type = this.getFlowType(index);
              this.controller.changeIndex(index);
            })
        }, (item: string, _index: number) => item)
      }
      .padding({ left: '10vp' })
      .width("100%")
      .height('40vp')

      Text("")
      Column() {
        Tabs({ controller: this.controller }) {
          ForEach(this.tabArrays, (item: string, _index: number) => {
            TabContent() {
              if (item == "支出") {
                ExpenseView({
                  onParamsChanged: (params: object) => {
                    this.params.set(FlowType.EXPENSE, params)
                  }
                })
              } else if (item == "收入") {
                IncomeView({
                  onParamsChanged: (params: object) => {
                    this.params.set(FlowType.INCOME, params)
                  }
                })
              } else if (item == "借贷") {
                BorrowOrLendView({
                  initSubType: this.subType == FlowType.LEND ? FlowType.LEND : FlowType.BORROW,
                  onParamsChanged: (params: object) => {
                    this.params.set(FlowType.BORROW, params)
                  }
                })
              } else if (item == "还债") {
                RefundOrReceiptView({
                  initSubType: this.subType == FlowType.RECEIPT ? FlowType.RECEIPT : FlowType.REFUND,
                  onParamsChanged: (params: object) => {
                    this.params.set(FlowType.REFUND, params)
                  }
                })
              } else if (item == "转账") {
                TransferView({
                  onParamsChanged: (params: object) => {
                    this.params.set(FlowType.TRANSFER, params)
                  }
                })
              } else if (item == "余额调整") {
                AdjustView({
                  onParamsChanged: (params: object) => {
                    this.params.set(FlowType.ADJUST, params)
                  }
                })
              }
            }
            .align(Alignment.TopStart)
          }, (item: string, _index: number) => item)
        }
        .vertical(false)
        .barWidth('100%')
        .barHeight(0)
        .animationDuration(300)
        .onAnimationStart((_index: number, targetIndex: number) => {
          this.type = this.getFlowType(targetIndex);
        })
        .width(Dimensions.FULL_PARENT)
        .height(Dimensions.FULL_PARENT)
        .backgroundColor(AppConfig.defaultBgColor)
      }
    }
    .padding({ top: px2vp(this.statusBarHeight) })
    .width('100%')
    .backgroundColor(Colors.white)
  }

  doSubmit() {
    let param = this.params.get(this.type)
    Http.post<void>("/v1/cashflows/add", param).then(() => {
      toast("记账成功")
      childController.call(this.type)
    }).catch((error: object) => {
      toastError(error)
    })
  }
}
