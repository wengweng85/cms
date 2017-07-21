package com.jspxcms.core.web.back;

import static com.jspxcms.core.support.Constants.CREATE;
import static com.jspxcms.core.support.Constants.DELETE_SUCCESS;
import static com.jspxcms.core.support.Constants.EDIT;
import static com.jspxcms.core.support.Constants.MESSAGE;
import static com.jspxcms.core.support.Constants.OPRT;
import static com.jspxcms.core.support.Constants.SAVE_SUCCESS;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.quartz.SchedulerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.web.PageableDefaults;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.jspxcms.common.orm.RowSide;
import com.jspxcms.common.web.Servlets;
import com.jspxcms.core.domain.ScheduleJob;
import com.jspxcms.core.domain.Site;
import com.jspxcms.core.domain.User;
import com.jspxcms.core.holder.ScheduleJobHolder;
import com.jspxcms.core.service.ScheduleJobService;
import com.jspxcms.core.support.Constants;
import com.jspxcms.core.support.Context;

@Controller
@RequestMapping("/core/schedule_job")
public class ScheduleJobController {
	private static final Logger logger = LoggerFactory
			.getLogger(ScheduleJobController.class);

	@RequiresPermissions("core:schedule_job:list")
	@RequestMapping("list.do")
	public String list(
			@PageableDefaults(sort = "id", sortDir = Direction.DESC) Pageable pageable,
			HttpServletRequest request, org.springframework.ui.Model modelMap) {
		Integer siteId = Context.getCurrentSiteId(request);
		Map<String, String[]> params = Servlets.getParameterValuesMap(request,
				Constants.SEARCH_PREFIX);
		List<ScheduleJob> list = service.findList(siteId, params,
				pageable.getSort());
		service.fetchNextFireTime(list);
		List<String> codes = scheduleJobHolder.getCodes();
		modelMap.addAttribute("codes", codes);
		modelMap.addAttribute("list", list);
		return "core/schedule_job/schedule_job_list";
	}

	@RequiresPermissions("core:schedule_job:create")
	@RequestMapping("create.do")
	public String create(Integer id, String code,
			org.springframework.ui.Model modelMap) {
		Site site = Context.getCurrentSite();
		User user = Context.getCurrentUser();
		if (id != null) {
			ScheduleJob bean = service.get(id);
			if (StringUtils.isBlank(code)) {
				code = bean.getCode();
			}
			modelMap.addAttribute("bean", bean);
		}
		List<String> codes = scheduleJobHolder.getCodes();
		modelMap.addAttribute("code", code);
		modelMap.addAttribute("codes", codes);
		modelMap.addAttribute("site", site);
		modelMap.addAttribute("user", user);
		modelMap.addAttribute(OPRT, CREATE);
		String path = scheduleJobHolder.getPaths().get(code);
		if (StringUtils.isNotBlank(path)) {
			return "forward:" + path;
		} else {
			return "core/schedule_job/schedule_job_form";
		}
	}

	@RequiresPermissions("core:schedule_job:edit")
	@RequestMapping("edit.do")
	public String edit(
			Integer id,
			Integer position,
			@PageableDefaults(sort = "id", sortDir = Direction.DESC) Pageable pageable,
			HttpServletRequest request, org.springframework.ui.Model modelMap) {
		Site site = Context.getCurrentSite();
		User user = Context.getCurrentUser();
		ScheduleJob bean = service.get(id);
		Map<String, String[]> params = Servlets.getParameterValuesMap(request,
				Constants.SEARCH_PREFIX);
		RowSide<ScheduleJob> side = service.findSide(site.getId(), params,
				bean, position, pageable.getSort());
		List<String> codes = scheduleJobHolder.getCodes();
		modelMap.addAttribute("code", bean.getCode());
		modelMap.addAttribute("codes", codes);
		modelMap.addAttribute("bean", bean);
		modelMap.addAttribute("dataMap", bean.getDataMap());
		modelMap.addAttribute("side", side);
		modelMap.addAttribute("position", position);
		modelMap.addAttribute("site", site);
		modelMap.addAttribute("user", user);
		modelMap.addAttribute(OPRT, EDIT);
		String path = scheduleJobHolder.getPaths().get(bean.getCode());
		if (StringUtils.isNotBlank(path)) {
			return "forward:" + path;
		} else {
			return "core/schedule_job/schedule_job_form";
		}
	}

	@RequiresPermissions("core:schedule_job:save")
	@RequestMapping("save.do")
	public String save(ScheduleJob bean, String redirect,
			HttpServletRequest request, RedirectAttributes ra)
			throws SchedulerException, ClassNotFoundException, ParseException {
		Integer siteId = Context.getCurrentSiteId(request);
		Integer userId = Context.getCurrentUserId(request);
		Map<String, String> dataMap = Servlets
				.getParameterMap(request, "data_");
		service.save(bean, dataMap, userId, siteId);
		service.scheduleJob(bean);
		logger.info("save ScheduleJob, name={}.", bean.getName());
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

	@RequiresPermissions("core:schedule_job:update")
	@RequestMapping("update.do")
	public String update(@ModelAttribute("bean") ScheduleJob bean,
			Integer position, String redirect, HttpServletRequest request,
			RedirectAttributes ra) throws SchedulerException, ParseException,
			ClassNotFoundException {
		Integer userId = Context.getCurrentUserId(request);
		Map<String, String> dataMap = Servlets
				.getParameterMap(request, "data_");
		service.update(bean, dataMap, userId);
		service.rescheduleJob(bean);
		logger.info("update ScheduleJob, name={}.", bean.getName());
		ra.addFlashAttribute(MESSAGE, SAVE_SUCCESS);
		if (Constants.REDIRECT_LIST.equals(redirect)) {
			return "redirect:list.do";
		} else {
			ra.addAttribute("id", bean.getId());
			ra.addAttribute("position", position);
			return "redirect:edit.do";
		}
	}

	@RequiresPermissions("core:schedule_job:delete")
	@RequestMapping("delete.do")
	public String delete(Integer[] ids, RedirectAttributes ra)
			throws SchedulerException {
		List<ScheduleJob> beans = service.delete(ids);
		service.unscheduleJobs(beans);
		for (ScheduleJob bean : beans) {
			logger.info("delete ScheduleJob, name={}.", bean.getName());
		}
		ra.addFlashAttribute(MESSAGE, DELETE_SUCCESS);
		return "redirect:list.do";
	}

	@ModelAttribute("bean")
	public ScheduleJob preloadBean(@RequestParam(required = false) Integer oid) {
		return oid != null ? service.get(oid) : null;
	}

	@Autowired
	private ScheduleJobHolder scheduleJobHolder;
	@Autowired
	private ScheduleJobService service;
}
