//
//  APIMacros.h
//  gepeng
//
//  Created by gepeng on 2019/10/1.
//  Copyright © 2019 gepeng. All rights reserved.
//

#ifndef APIMacros_h
#define APIMacros_h


#define Host                        @"https://shop.bayi-shop.com/mobile"//域名

#pragma mark ---------------------个人中心---------------------

#pragma mark - 我的页面
/**
 *我的页面
 *https://shop.bayi-shop.com/mobile/member/index
 *key      token
 */
#define Hostmemberindex         Host@"/member/index"//我的页面



#pragma mark - 用户头像上传
/**
 *用户头像上传
 *https://shop.bayi-shop.com/mobile/member/upload
 *key       token
 *pic       (上传图片的路径)file上传
 */
#define Hostmemberupload         Host@"/member/upload"//用户头像上传


#pragma mark - 个人资料编辑
/**
 *个人资料编辑
 *https://shop.bayi-shop.com/mobile/member/my_edit
 *key       token
 *commit    是否提交  默认0  1确认提交
 *member_name   昵称
 *member_sex    性别
 *member_email  邮箱
 */
#define Hostmembermy_edit         Host@"/member/my_edit"//个人资料编辑


#pragma mark - 收货地址列表-获取个人收货地址
/**
 *收货地址列表-获取个人收货地址
 *https://shop.bayi-shop.com/mobile/Memberaddress/address_list
 *key      token
 */
#define HostMemberaddressaddress_list         Host@"/Memberaddress/address_list"//收货地址列表-获取个人收货地址

#pragma mark - 添加收货地址
/**
 *添加收货地址
 *https://shop.bayi-shop.com/mobile/Memberaddress/address_add
 *key      token
 *true_name 收货人姓名
 *mob_phone 手机号
 *city_id   城市ID
 *area_id   县/区ID
 *address   详细地址
 *area_info 省 市 县   空格拼接
 *is_default    0不默认，1默认地址
 *latitude  纬度
 *longitude 经度
 */
#define HostMemberaddressaddress_add         Host@"/Memberaddress/address_add"//添加收货地址


#pragma mark - 编辑收货地址
/**
 *编辑收货地址
 *https://shop.bayi-shop.com/mobile/Memberaddress/address_edit
 *key      token
 *true_name 收货人姓名
 *mob_phone 手机号
 *city_id   城市ID
 *area_id   县/区ID
 *address   详细地址
 *area_info 省 市 县   空格拼接
 *is_default    0不默认，1默认地址
 *address_id    地址自增ID
 *latitude  纬度
 *longitude 经度
 */
#define HostMemberaddressaddress_edit         Host@"/Memberaddress/address_edit"//编辑收货地址

#pragma mark - 删除收货地址
/**
 *删除收货地址
 *https://shop.bayi-shop.com/mobile/Memberaddress/address_del
 *key      token
 *address_id    地址自增ID
 */
#define HostMemberaddressaddress_del        Host@"/Memberaddress/address_del"//删除收货地址

#pragma mark - 实名认证
/**
*实名认证
*https://shop.bayi-shop.com/mobile/memberauth/auth
*member_id Number 用户id
*username String 姓名
*idcard String 身份证号
*member_bankname String 银行名称
*member_bankcard String 银行卡账号
*member_idcard_image2 String 身份证正面照，file文件
*member_idcard_image3 String 身份证反面照，file文件
*member_provinceid Number 0  省id
*member_cityid Number 0 市id, 没有传0
*member_areaid Number 0 区id, 没有传0
*member_townid Number 0 镇/乡id， 没有传0
*member_villageid Number 0 村id, 没有传0
*member_areainfo String 地区信息
*commit 等于1为提交，否则为获取数据
*/
#define HostMmemberauthauth        Host@"/memberauth/auth"//实名认证


#pragma mark - 邀请好友 --- H5页面
/**
 *邀请好友 --- H5页面
 *https://shop.bayi-shop.com/wap/tmpl/member/member_inviter_poster.html
 *key      token //?key=bd271df2d303ad1cefc8f21e99a70431
 */
#define member_inviter_poster        @"https://shop.bayi-shop.com/wap/tmpl/member/member_inviter_poster.html"//邀请好友 --- H5页面

#pragma mark - 提现记录
/**
 *提现记录
 *https://shop.bayi-shop.com/mobile/memberfund/pdcashlist
 *key           token
 *page          分页，默认第1页
 *pagesize      每页数量，默认5条
 */
#define Hostmemberfundpdcashlist        Host@"/memberfund/pdcashlist"//提现记录




#pragma mark - 提现申请
/**
 *提现申请
 *https://shop.bayi-shop.com/mobile/member/my_withdraw
 *key                   token
 *amount                提现金额
 *commission            手续费比例
 *memberbank_name       开户行
 *memberbank_no         银行卡账号
 *memberbank_truename   持卡人姓名
 */
#define Hostmembermy_withdraw        Host@"/member/my_withdraw"//提现申请


#pragma mark - 获取可提现金额/银行卡
/**
 *获取可提现金额/银行卡
 *https://shop.bayi-shop.com/mobile/member/my_asset
 *key       token
 *fields    available：可用积分；point：冻结积分；predepoit：储值卡；transaction：交易码
 */
#define Hostmembermy_asset        Host@"/member/my_asset"//获取可提现金额/银行卡


#pragma mark - 钱包页面个人资产查询
/**
 *钱包页面个人资产查询
 *https://shop.bayi-shop.com/mobile/member/wallet
 *key      token
 */
#define Hostmemberwallet        Host@"/member/wallet"//钱包页面个人资产查询


#pragma mark - 获取推荐下级信息
/**
 *获取推荐下级信息
 *https://shop.bayi-shop.com/mobile/member/inviter
 *key           token
 */
#define Hostmemberinviter        Host@"/member/inviter"//获取推荐下级信息


#pragma mark - 可用积分转换为交易码
/**
 *可用积分转换为交易码
 *https://shop.bayi-shop.com/mobile/Membertransform/PointTransform
 *key               token
 *transtype         1为到储值卡，2为到交易码
 *point             数量
 */
#define HostMembertransformPointTransform       Host@"/Membertransform/PointTransform"//可用积分转换为交易码


#pragma mark - 积分交易明细
/**
 *积分交易明细
 *https://shop.bayi-shop.com/mobile/memberpoints/pointslog
 *key      token
 *page          分页，默认第1页
 *pagesize      每页数量，默认5条
 */
#define Hostmemberpointspointslog        Host@"/memberpoints/pointslog"//积分交易明细


#pragma mark - 储值卡交易明细
/**
 *储值卡交易明细
 *https://shop.bayi-shop.com/mobile/memberfund/predepositlog
 *key      token
 *page          分页，默认第1页
 *pagesize      每页数量，默认5条
 */
#define Hostmemberfundpredepositlog        Host@"/memberfund/predepositlog"//储值卡交易明细


#pragma mark - 交易码交易明细
/**
 *交易码交易明细
 *https://shop.bayi-shop.com/mobile/memberfund/transactionlog
 *key      token
 *page          分页，默认第1页
 *pagesize      每页数量，默认5条
 */
#define Hostmemberpointstransactionlog        Host@"/memberpoints/transactionlog"//交易码交易明细



#pragma mark ---------------------首页---------------------

#pragma mark - 首页导航-获取首页轮播图，导航按钮，促销商品
/**
 *获取首页轮播图，导航按钮，促销商品
 *https://shop.bayi-shop.com/mobile/Index/index
 */
#define HostIndexIndex              Host@"/Index/index" //获取首页轮播图，导航按钮，促销商品

#pragma mark - 获取app首页推荐商品
/**
 *获取app首页推荐商品
 *https://shop.bayi-shop.com/mobile/Index/getCommendGoods
 *limit 每页数量
 *page 页码 0 1 2 3 4
 */
#define HostIndexgetCommendGoods    Host@"/Index/getCommendGoods" //获取app首页推荐商品

#pragma mark - 搜索页面热门搜索词
/**
 *搜索页面热门搜索词
 *https://shop.bayi-shop.com/mobile/index/search_key_list
 */
#define Hostindexsearch_key_list         Host@"/index/search_key_list"//搜索页面热门搜索词

#pragma mark - 系统消息列表
/**
 *获取消息列表
 *https://shop.bayi-shop.com/index.php/mobile/Membermessage/systemmsg?key=c5332610eb543bec515404889c8c41b8&page=1
 *page      页码
 *key      token
 */
#define HostMembermessagesystemmsg         Host@"/Membermessage/systemmsg"//获取消息列表


#pragma mark - 用户注册协议
/**
 *用户注册协议
 *https://shop.bayi-shop.com/wap/agreement.html
 */
#define wapagreementhtml         @"https://shop.bayi-shop.com/wap/agreement.html"//用户注册协议

#pragma mark ---------------------店铺---------------------

#pragma mark - 店铺列表-获取店铺列表
/**
 *获取店铺列表
 *https://shop.bayi-shop.com/mobile/Storelist/index
 *cate_id    分类id
 *keyword 关键词
 */
#define HostStorelistindex          Host@"/Storelist/index"//获取店铺列表

#pragma mark - 店铺首页-获取店铺信息
/**
 *获取店铺信息
 *https://shop.bayi-shop.com/mobile/Store/store_info?store_id=1
 *store_id 店铺ID
 */
#define HostStorestore_info         Host@"/Store/store_info"//获取店铺信息

#pragma mark - 获取店铺商品-获取某店铺所有商品 ---每页10条
/**
 *获取某店铺所有商品 ---每页10条
 *https://shop.bayi-shop.com/mobile/Store/store_goods?store_id=1&page=1
 *store_id 店铺ID
 *page 页码
 *key 0为默认综合排序 2为价格排序 3为销量排序 5为人气排序 order
 *order 0按照默认排序，1为正序，2为反序
 *price_from 价格区间 开始
 *price_to 价格区间 结束
 *keyword 模糊查询商品名称
 */
#define HostStorestore_goods         Host@"/Store/store_goods"//获取某店铺所有商品 ---每页10条

#pragma mark - 店铺分类
/**
 *店铺分类
 *https://shop.bayi-shop.com/mobile/storelist/getStoreClassList
 */
#define HostStorelistgetStoreClassList          Host@"/Storelist/getStoreClassList"//店铺分类

#pragma mark - 获取店铺首页推荐商品
/**
 *获取店铺首页推荐商品
 *https://shop.bayi-shop.com/mobile/Store/GetStoreCommentGoods?store_id=1
 *store_id 店铺ID
 */
#define HostStoreGetStoreCommentGoods         Host@"/Store/GetStoreCommentGoods"//获取店铺首页推荐商品

#pragma mark ---------------------购物车---------------------

#pragma mark - 商品加入购物车-把商品加入到购物车内
/**
 *把商品加入到购物车内
 *https://shop.bayi-shop.com/mobile/membercart/cart_add?goods_id=1&quantity=1&key=token
 *goods_id      商品ID
 *quantity      加入数量
 *key       token  不可以为空
 */
#define Hostmembercartcart_add         Host@"/membercart/cart_add"//把商品加入到购物车内


#pragma mark - 获取购物车内全部商品
/**
 *获取购物车内全部商品
 *https://shop.bayi-shop.com/mobile/membercart/cart_list?key=c4a2d4bf8046fdada41da0dece8e3ad7
 *key       token  不可以为空
 */
#define Hostmembercartcart_list         Host@"/membercart/cart_list"//获取购物车内全部商品


#pragma mark - 删除购物车商品 -把商品从购物车删除
/**
 *删除购物车商品
 *https://shop.bayi-shop.com/mobile/Membercart/cart_del
 *key       token  不可以为空
 *cart_id   购物车ID
 */
#define Hostmembercartcart_del         Host@"/membercart/cart_del"//删除购物车商品



#pragma mark ---------------------分类---------------------

#pragma mark - 分类首页-获取第一大类
/**
 *获取第一大类
 *https://shop.bayi-shop.com/mobile/goodsclass/index
 */
#define HostgoodsclassIndex         Host@"/goodsclass/index"//获取第一大类

#pragma mark - 获取右侧分类-获取分类二级三级目录
/**
 *获取分类二级三级目录
 *https://shop.bayi-shop.com/mobile/goodsclass/get_child_all.html
 *gc_id 分类id
 */
#define Hostgoodsclassget_child_all Host@"/goodsclass/get_child_all.html"//获取分类二级三级目录

#pragma mark ---------------------商品---------------------

#pragma mark - 商品详情页-获取商品详情
/**
 *获取商品详情
 *https://shop.bayi-shop.com/mobile/goods/goods_detail?goods_id=8
 *goods_id 商品ID
 */
#define Hostgoodsgoods_detail         Host@"/goods/goods_detail"//获取商品详情

#warning ----和店铺商品接口一样----
//#error ----和店铺商品接口一样----
#pragma mark - 获取店铺商品-获取某店铺所有商品 ---每页10条
/**
 *获取某店铺所有商品 ---每页10条
 *https://shop.bayi-shop.com/mobile/Store/store_goods.html?store_id=1&page=1
 *gc_id 分类ID
 *page 页码
 *key 0为默认综合排序 2为价格排序 3为销量排序 5为人气排序 order
 *order 0按照默认排序，1为正序，2为反序
 *price_from 价格区间 开始
 *price_to 价格区间 结束
 *keyword 模糊查询商品名称
 */
#define HostStorestore_goodshtml         Host@"/Store/store_goods.html"//获取某店铺所有商品 ---每页10条

#pragma mark - 商品搜索
/**
 *商品搜索
 *https://shop.bayi-shop.com/mobile/goods/goods_list?page=1&keyword=西红柿
 *keyword   关键字
 *page      页码
 *key       token  可以为空
 *order 0按照默认排序，1为正序，2为反序
 *price_from 价格区间 开始
 *price_to 价格区间 结束
 *gc_id 分类ID
 */
#define Hostgoodsgoods_list         Host@"/goods/goods_list"//商品搜索

#pragma mark ---------------------订单流程---------------------



#pragma mark - 所有订单 --获取全部订单
/**
 *所有订单 --获取全部订单
 *https://shop.bayi-shop.com/mobile/Memberorder/order_list
 *key           token
 *state_type
 state_new:     待付款 ，
 state_pay：     待发货 ，
 state_send：    待收货 ，
 state_notakes： 待自提 ，
 state_noeval：  待评价 ，
 state_success： 已完成 ，
 state_cancel：  已经取消的订单 ，
 为空             表示全部订单
 *
 *order_key     订单号和商品名称查询
 *page          分页，默认第1页
 *pagesize      每页数量，默认5条
 */
#define HostMemberorderorder_list         Host@"/Memberorder/order_list"//所有订单 --获取全部订单

#pragma mark - 验证支付密码
/**
 *验证支付密码 -输入支付密码后，调用此接口验证是否正确
 *https://shop.bayi-shop.com/mobile/Memberbuy/check_pd_pwd
 *password  支付密码
 *key       token
 */
#define HostMemberbuycheck_pd_pwd         Host@"/Memberbuy/check_pd_pwd"//验证支付密码

#pragma mark - 生成充值订单并支付 -充值储值卡
/**
 *生成充值订单并支付 -充值储值卡
 *https://shop.bayi-shop.com/mobile/Memberpayment/PdaddPay
 *payment_code  支付宝支付：alipay_app,微信支付：wxpay_app
 *pdr_amount    充值额度
 *key           token
 */
#define HostMemberpaymentPdaddPay         Host@"/Memberpayment/PdaddPay"//生成充值订单并支付 -充值储值卡


#pragma mark - 订单查看 - 查看订单详情
/**
 *订单查看 - 查看订单详情
 *https://shop.bayi-shop.com/index.php/mobile/Memberorder/order_info
 *order_id      订单ID
 *key           token
 */
#define HostMemberorderorder_info         Host@"/Memberorder/order_info"//订单查看 - 查看订单详情


#pragma mark - 购买商品--第一步，生成购物信息
/**
 *购买商品--第一步，生成购物信息
 *https://shop.bayi-shop.com/index.php/mobile/Memberbuy/buy_step1
 *?key=549a4cd64bb3013f6dd56c1c41fa2c8c&cart_id=176|1&ifcart=0
 *cart_id   商品  ----    ID|数量,ID|数量,ID|数量
 *ifcart    默认为空，为直接购物，1为从购物车
 *key       token
 */
#define HostMemberbuybuy_step1         Host@"/Memberbuy/buy_step1"//购买商品--第一步，生成购物信息


#pragma mark - 购买商品--第二步，生成订单
/**
 *购买商品--第二步，生成订单  生成订单之后直接调用第三步
 *https://shop.bayi-shop.com/index.php/mobile/Memberbuy/buy_step2
 *cart_id   商品  ----    ID|数量,ID|数量,ID|数量
 *ifcart    默认为空，为直接购物，1为从购物车
 *key       token
 *address_id    收货地址ID
 *vat_hash  从第一步接口得到的hash
 *pay_name  支付类型    online
 *invoice_id    默认为0，发票ID，无发票设置
 *voucher   0|店铺ID|0
 *offpay_hash           可以为空
 *offpay_hash_batch     可以为空
 */
#define HostMemberbuybuy_step2         Host@"/Memberbuy/buy_step2"//购买商品--第二步，生成订单


#pragma mark - 购买商品--第三步，获取订单信息
/**
 *购买商品--第三步，获取订单信息
 *https://shop.bayi-shop.com/index.php/mobile/memberbuy/pay
 *pay_sn    支付单号  20位
 *key       token
 */
#define Hostmemberbuypay         Host@"/memberbuy/pay"//购买商品--第三步，获取订单信息

#pragma mark - 购买商品--第四步，购买
/**
 *购买商品--第四步，购买
 *https://shop.bayi-shop.com/mobile/Memberpayment/pay_new
 *pay_sn    支付单号  20位
 *key       token
 *password  支付密码
 *pd_pay    1
 *payment_code  predeposit
 */
#define HostMemberpaymentpay_new         Host@"/Memberpayment/pay_new"//购买商品--第四步，购买




#pragma mark - 支付成功后获取随机商品
/**
 *支付成功后获取随机商品
 *https://shop.bayi-shop.com/mobile/Goods/getRandGoods
 */
#define HostGoodsgetRandGoods         Host@"/Goods/getRandGoods"//支付成功后获取随机商品


#pragma mark - 获取物流信息 - 获取订单物流信息
/**
 *获取物流信息 - 获取订单物流信息
 *https://shop.bayi-shop.com/mobile/Memberorder/get_express
 *express_code      物流信息代码
 *shipping_code     物流号
 *phone             收货人手机号
 *key               token值
 */
#define HostMemberorderget_express         Host@"/Memberorder/get_express"//获取物流信息 - 获取订单物流信息


#pragma mark - 修改订单状态 - 取消订单 删除订单 确认收货
/**
 *修改订单状态 - 取消订单 删除订单 确认收货
 *https://shop.bayi-shop.com/mobile/memberorder/change_state
 *order_id     订单ID
 *state_type
 *order_cancel ：取消订单
 order_delete  ：删除订单
 order_receive  : 确认收货
 *key           token值
 *state_info    取消原因，由用户填写，可以为空
 *state_info1   取消原因，由用户选择，可以为空
 */
#define Hostmemberorderchange_state         Host@"/memberorder/change_state"//修改订单状态 - 取消订单 删除订单 确认收货

#pragma mark ---------------------商学院---------------------

#pragma mark ---------------------用户密码管理---------------------

#pragma mark - 注册
/**
 *注册
 *https://shop.bayi-shop.com/mobile/login/register
 *username      用户名，手机号
 *password      密码
 *password_confirm  确认密码
 *client        客户端口 ：'android', 'wap', 'wechat', 'ios', 'windows', 'jswechat'
 *inviter_code  推荐码，5位大写英文字母
 *sms_captcha   验证码
 *log_type      短信类型:1为注册,2为登录,3为找回密码,4绑定手机,5安全验证,默认为1
 */
#define Hostloginregister         Host@"/login/register"//注册

#pragma mark - 登陆-APP登陆使用，暂时只做密码登陆
/**
 *APP登陆使用，暂时只做密码登陆
 *https://shop.bayi-shop.com/mobile/login/index
 *username      用户名，手机号
 *password      密码
 *client        客户端口 ：'android', 'wap', 'wechat', 'ios', 'windows', 'jswechat'
 */
#define Hostloginindex         Host@"/login/index"//APP登陆使用，暂时只做密码登陆

#pragma mark - 验证码发送-发送手机验证码 包含 登陆 注册 修改密码 修改支付密码 其他
/**
 *发送手机验证码 包含 登陆 注册 修改密码 修改支付密码 其他
 *https://shop.bayi-shop.com/mobile/Connect/get_sms_captcha
 *member_mobile         手机号
 *type                  验证码类型（1登录2注册3修改密码4绑定手机5绑定邮箱6安全验证）
 */
#define HostConnectget_sms_captcha         Host@"/Connect/get_sms_captcha"//发送手机验证码 包含 登陆 注册 修改密码 修改支付密码 其他



#pragma mark - 登陆密码修改-修改登陆密码
/**
 *登陆密码修改-修改登陆密码
 *https://shop.bayi-shop.com/mobile/Memberaccount/modify_paypwd_step4
 *key                   token值
 *password              新登陆密码
 *confirm_password      确认新密码
 *auth_code             手机验证码
 */
#define HostMemberaccountmodify_paypwd_step4         Host@"/Memberaccount/modify_paypwd_step4"//登陆密码修改-修改登陆密码



#pragma mark - 登陆密码修改-修改登陆密码
/**
 *登陆密码修改-修改登陆密码
 *https://shop.bayi-shop.com/mobile/Memberaccount/modify_password_step4
 *mobile_key            手机号,如果没有token，可使用此参数代替
 *key                   token值
 *password              新登陆密码
 *confirm_password      确认新密码
 *auth_code             手机验证码
 */
#define HostMemberaccountmodify_password_step4         Host@"/Memberaccount/modify_password_step4"//登陆密码修改-修改登陆密码


#pragma mark ---------------------分界线---------------------


#pragma mark - 获取版本号 -- 获取当前APP最新版本
/**
 *获取版本号 -- 获取当前APP最新版本
 *https://shop.bayi-shop.com/mobile/Version/GetVersion
 *version_num       当前APP版本号
 *type              iOS传2，Android传1
 */
#define HostVersionGetVersion         Host@"/Version/GetVersion"//获取版本号 -- 获取当前APP最新版本








#pragma mark - app调用接口


#endif /* APIMacros_h */
