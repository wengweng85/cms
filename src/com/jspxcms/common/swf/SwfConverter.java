package com.jspxcms.common.swf;

import java.io.File;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

// D:\\programcommon\\swftools\\pdf2swf.exe Paper.pdf -o Paper%.swf -f -T 9 -t -s storeallcharacters
public class SwfConverter {
	private static final Logger logger = LoggerFactory
			.getLogger(SwfConverter.class);

	public static void pdf2swf(File from, File to, String exe) throws Exception {
		Runtime r = Runtime.getRuntime();

		Process p = r.exec(exe + " " + from.getPath() + " -o " + to.getPath()
				+ " -f -T 9 -t -s storeallcharacters");
		logger.debug(IOUtils.toString(p.getInputStream()));
		logger.debug(IOUtils.toString(p.getErrorStream()));
	}

	// private static boolean isWindows() {
	// String osName = System.getProperty("os.name");
	// return osName.toLowerCase().indexOf("windows") != -1;
	// }

	public static void main(String[] args) throws Exception {
		File pdfFile = new File("d:\\Jspxcms_x.pdf");
		File swfFile = new File("d:\\jspxcms_x.swf");
		String exe = "D:\\programcommon\\swftools\\pdf2swf.exe";
		pdf2swf(pdfFile, swfFile, exe);
	}
}
