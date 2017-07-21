// 主页面地址
var homepage = "http://127.0.0.1:8090/zynljsweb";
/**
 * 加入收藏
 */
function addFavorite() {
	if (document.all) {
		try {
			window.external.addFavorite(homepage, '杭州市技能鉴定工作网');
		} catch (e) {
			alert("加入收藏失败，请使用Ctrl+D进行添加");
		}
	} else if (window.sidebar) {
		window.sidebar.addPanel('杭州市技能鉴定工作网', homepage, "");
	} else {
		alert("加入收藏失败，请使用Ctrl+D进行添加");
	}
}
/**
 * 设为首页
 */
function setHomepage() {
	if (document.all) {
		document.body.style.behavior = 'url(#default#homepage)';
		document.body.setHomePage(homepage);
	} else if (window.sidebar) {
		if (window.netscape) {
			try {
				netscape.security.PrivilegeManager
						.enablePrivilege("UniversalXPConnect");
			} catch (e) {
				alert("该操作被浏览器拒绝，如果想启用该功能，请在地址栏内输入 about:config,\n然后将项 signed.applets.codebase_principal_support 值该为true");
			}
		}
		var prefs = Components.classes['@mozilla.org/preferences-service;1']
				.getService(Components.interfaces.nsIPrefBranch);
		prefs.setCharPref('browser.startup.homepage', homepage);
	} else {
		alert('您的浏览器不支持自动自动设置首页, 请使用浏览器菜单手动设置!');
	}
}