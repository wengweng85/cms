package com.jspxcms.core.web.back;

import static com.jspxcms.core.support.Constants.CREATE;
import static com.jspxcms.core.support.Constants.DELETE_SUCCESS;
import static com.jspxcms.core.support.Constants.EDIT;
import static com.jspxcms.core.support.Constants.MESSAGE;
import static com.jspxcms.core.support.Constants.OPRT;
import static com.jspxcms.core.support.Constants.SAVE_SUCCESS;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.authz.annotation.RequiresPermissions;
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
import com.jspxcms.common.web.Servlets;
import com.jspxcms.core.domain.PublishPoint;
import com.jspxcms.core.service.PublishPointService;
import com.jspxcms.core.support.Constants;

@Controller
@RequestMapping("/core/publish_point")
public class PublishPointController {
	private static final Logger logger = LoggerFactory
			.getLogger(PublishPointController.class);

	@RequiresPermissions("core:publish_point:list")
	@RequestMapping("list.do")
	public String list(
			@PageableDefaults(sort = { "seq", "id" }) Pageable pageable,
			HttpServletRequest request, org.springframework.ui.Model modelMap) {
		Map<String, String[]> params = Servlets.getParameterValuesMap(request,
				Constants.SEARCH_PREFIX);
		List<PublishPoint> list = service.findList(params, pageable.getSort());
		modelMap.addAttribute("list", list);
		return "core/publish_point/publish_point_list";
	}

	@RequiresPermissions("core:publish_point:create")
	@RequestMapping("create.do")
	public String create(Integer id, org.springframework.ui.Model modelMap) {
		if (id != null) {
			PublishPoint bean = service.get(id);
			modelMap.addAttribute("bean", bean);
		}
		modelMap.addAttribute(OPRT, CREATE);
		return "core/publish_point/publish_point_form";
	}

	@RequiresPermissions("core:publish_point:edit")
	@RequestMapping("edit.do")
	public String edit(Integer id, Integer position, @PageableDefaults(sort = {
			"seq", "id" }) Pageable pageable, HttpServletRequest request,
			org.springframework.ui.Model modelMap) {
		PublishPoint bean = service.get(id);
		Map<String, String[]> params = Servlets.getParameterValuesMap(request,
				Constants.SEARCH_PREFIX);
		RowSide<PublishPoint> side = service.findSide(params, bean, position,
				pageable.getSort());
		modelMap.addAttribute("bean", bean);
		modelMap.addAttribute("side", side);
		modelMap.addAttribute("position", position);
		modelMap.addAttribute(OPRT, EDIT);
		return "core/publish_point/publish_point_form";
	}

	@RequiresPermissions("core:publish_point:save")
	@RequestMapping("save.do")
	public String save(PublishPoint bean, String redirect,
			HttpServletRequest request, RedirectAttributes ra) {
		service.save(bean);
		logger.info("save PublishPoint, name={}.", bean.getName());
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

	@RequiresPermissions("core:publish_point:update")
	@RequestMapping("update.do")
	public String update(@ModelAttribute("bean") PublishPoint bean,
			Integer position, String redirect, RedirectAttributes ra) {
		service.update(bean);
		logger.info("update PublishPoint, name={}.", bean.getName());
		ra.addFlashAttribute(MESSAGE, SAVE_SUCCESS);
		if (Constants.REDIRECT_LIST.equals(redirect)) {
			return "redirect:list.do";
		} else {
			ra.addAttribute("id", bean.getId());
			ra.addAttribute("position", position);
			return "redirect:edit.do";
		}
	}

	@RequiresPermissions("core:publish_point:delete")
	@RequestMapping("delete.do")
	public String delete(Integer[] ids, RedirectAttributes ra) {
		PublishPoint[] beans = service.delete(ids);
		for (PublishPoint bean : beans) {
			logger.info("delete PublishPoint, name={}.", bean.getName());
		}
		ra.addFlashAttribute(MESSAGE, DELETE_SUCCESS);
		return "redirect:list.do";
	}

	@ModelAttribute("bean")
	public PublishPoint preloadBean(@RequestParam(required = false) Integer oid) {
		return oid != null ? service.get(oid) : null;
	}

	@Autowired
	private PublishPointService service;
}
