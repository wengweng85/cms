package com.jspxcms.core.web.back;

import static com.jspxcms.core.support.Constants.CREATE;
import static com.jspxcms.core.support.Constants.DELETE_SUCCESS;
import static com.jspxcms.core.support.Constants.EDIT;
import static com.jspxcms.core.support.Constants.MESSAGE;
import static com.jspxcms.core.support.Constants.OPRT;
import static com.jspxcms.core.support.Constants.SAVE_SUCCESS;

import java.io.File;
import java.io.FileFilter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.apache.shiro.authz.annotation.RequiresRoles;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefaults;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jspxcms.common.orm.RowSide;
import com.jspxcms.common.web.PathResolver;
import com.jspxcms.common.web.Servlets;
import com.jspxcms.core.domain.Org;
import com.jspxcms.core.domain.PublishPoint;
import com.jspxcms.core.domain.Site;
import com.jspxcms.core.service.OrgService;
import com.jspxcms.core.service.PublishPointService;
import com.jspxcms.core.service.SiteService;
import com.jspxcms.core.support.Constants;
import com.jspxcms.core.support.Context;

@Controller
@RequestMapping("/core/site")
public class SiteController {
	private static final Logger logger = LoggerFactory
			.getLogger(SiteController.class);

	@RequiresRoles("super")
	@RequiresPermissions("core:site:list")
	@RequestMapping("list.do")
	public String list(
			@PageableDefaults(sort = "treeNumber") Pageable pageable,
			HttpServletRequest request, org.springframework.ui.Model modelMap) {
		Map<String, String[]> params = Servlets.getParameterValuesMap(request,
				Constants.SEARCH_PREFIX);
		List<Site> list = service.findList(params, pageable.getSort());
		modelMap.addAttribute("list", list);
		return "core/site/site_list";
	}

	@RequiresRoles("super")
	@RequiresPermissions("core:site:create")
	@RequestMapping("create.do")
	public String create(Integer id, HttpServletRequest request,
			org.springframework.ui.Model modelMap) {
		Site bean = null;
		if (id != null) {
			bean = service.get(id);
		}
		if (bean == null) {
			bean = Context.getCurrentSite(request);
		}
		Org org = orgService.findRoot();
		modelMap.addAttribute("org", org);

		List<PublishPoint> publishPointList = publishPointService
				.findByType(PublishPoint.TYPE_HTML);
		modelMap.addAttribute("publishPointList", publishPointList);

//		List<String> themeList = new ArrayList<String>();
//		// TODO 应该是被复制的站点的模版列表
//		themeList.add(bean.getTemplateTheme());
//		modelMap.addAttribute("themeList", themeList);
		modelMap.addAttribute("bean", bean);
		modelMap.addAttribute(OPRT, CREATE);
		return "core/site/site_form";
	}

	@RequiresRoles("super")
	@RequiresPermissions("core:site:edit")
	@RequestMapping("edit.do")
	public String edit(Integer id, Integer position,
			@PageableDefaults(sort = "treeNumber") Pageable pageable,
			HttpServletRequest request, org.springframework.ui.Model modelMap) {
		Site bean = service.get(id);
		Map<String, String[]> params = Servlets.getParameterValuesMap(request,
				Constants.SEARCH_PREFIX);
		RowSide<Site> side = service.findSide(params, bean, position,
				pageable.getSort());

		List<PublishPoint> publishPointList = publishPointService
				.findByType(PublishPoint.TYPE_HTML);
		modelMap.addAttribute("publishPointList", publishPointList);

		String templateBase = bean.getSiteBase("");
		File templateBaseFile = new File(pathResolver.getPath(templateBase,
				Constants.TEMPLATE_STORE_PATH));
		File[] themeFiles = templateBaseFile.listFiles(new FileFilter() {
			public boolean accept(File pathname) {
				return pathname.isDirectory();
			}
		});
		List<String> themeList = new ArrayList<String>();
		if (themeFiles != null) {
			for (File themeFile : themeFiles) {
				themeList.add(themeFile.getName());
			}
		}

		if (themeList.isEmpty()) {
			themeList.add("default");
		}
		modelMap.addAttribute("themeList", themeList);
		modelMap.addAttribute("bean", bean);
		modelMap.addAttribute("parent", bean.getParent());
		modelMap.addAttribute("org", bean.getOrg());
		modelMap.addAttribute("side", side);
		modelMap.addAttribute("position", position);
		modelMap.addAttribute(OPRT, EDIT);
		return "core/site/site_form";
	}

	@RequiresRoles("super")
	@RequiresPermissions("core:site:save")
	@RequestMapping("save.do")
	public String save(Site bean, Integer parentId, Integer orgId,
			Integer htmlPublishPointId, String redirect,
			HttpServletRequest request, RedirectAttributes ra) {
		Site site = Context.getCurrentSite(request);
		Integer userId = Context.getCurrentUserId(request);
		service.save(bean, parentId, orgId, htmlPublishPointId, userId, site);
		logger.info("save Site, name={}.", bean.getName());
		ra.addFlashAttribute(MESSAGE, SAVE_SUCCESS);
		if (Constants.REDIRECT_LIST.equals(redirect)) {
			return "redirect:list.do";
		} else if (Constants.REDIRECT_CREATE.equals(redirect)) {
			return "redirect:create.do";
		} else {
			ra.addAttribute("id", bean.getId());
			return "redirect:edit.do";
		}
	}

	@RequiresRoles("super")
	@RequiresPermissions("core:site:update")
	@RequestMapping("update.do")
	public String update(@ModelAttribute("bean") Site bean, Integer parentId,
			Integer orgId, Integer htmlPublishPointId, Integer position,
			String redirect, RedirectAttributes ra) {
		service.update(bean, parentId, orgId, htmlPublishPointId);
		logger.info("update Site, name={}.", bean.getName());
		ra.addFlashAttribute(MESSAGE, SAVE_SUCCESS);
		if (Constants.REDIRECT_LIST.equals(redirect)) {
			return "redirect:list.do";
		} else {
			ra.addAttribute("id", bean.getId());
			ra.addAttribute("position", position);
			return "redirect:edit.do";
		}
	}

	@RequiresRoles("super")
	@RequiresPermissions("core:site:delete")
	@RequestMapping("delete.do")
	public String delete(Integer[] ids, RedirectAttributes ra) {
		Site[] beans = service.delete(ids);
		for (Site bean : beans) {
			logger.info("delete Site, name={}.", bean.getName());
		}
		ra.addFlashAttribute(MESSAGE, DELETE_SUCCESS);
		return "redirect:list.do";
	}

	/**
	 * 检查编码是否存在
	 * 
	 * @return
	 */
	@RequestMapping("check_number.do")
	public void checkUsername(String number, String original,
			HttpServletResponse response) {
		if (StringUtils.isBlank(number)) {
			Servlets.writeHtml(response, "false");
			return;
		}
		if (StringUtils.equals(number, original)) {
			Servlets.writeHtml(response, "true");
			return;
		}
		// 检查数据库是否重名
		boolean exist = service.numberExist(number);
		Servlets.writeHtml(response, exist ? "false" : "true");
	}

	@ModelAttribute("bean")
	public Site preloadBean(@RequestParam(required = false) Integer oid) {
		return oid != null ? service.get(oid) : null;
	}

	@Autowired
	private PublishPointService publishPointService;
	@Autowired
	private OrgService orgService;
	@Autowired
	private SiteService service;
	@Autowired
	private PathResolver pathResolver;
}
