<%@ page contentType="text/html; charset=UTF-8"
	import="java.util.*,
 com.vignette.as.client.common.*,
 com.vignette.as.client.common.ref.*,
 com.vignette.as.client.javabean.*,
 com.vignette.cms.client.common.*,
 com.vignette.ext.templating.util.ContentUtil"%>
<%!String unAccent(String s) {
		s = s.replaceAll("[èéêë]", "e");
		s = s.replaceAll("[ûùú]", "u");
		s = s.replaceAll("[ïîí]", "i");
		s = s.replaceAll("[àâãá]", "a");
		s = s.replaceAll("[ôõó]", "o");
		s = s.replaceAll("ç", "c");

		s = s.replaceAll("[ÈÉÊË]", "E");
		s = s.replaceAll("[ÛÙÚ]", "U");
		s = s.replaceAll("[ÏÎÍ]", "I");
		s = s.replaceAll("[ÀÂÃÁ]", "A");
		s = s.replaceAll("ÔÕÓ", "O");
		s = s.replaceAll("Ç", "c");
		s = s.replaceAll(" ", "_");

		return s;
	}%>
<html>
<body>
	<title>Migration Tool - Make Script</title>
	<link href="/AppConsole/common/styles/vmc.css" rel="stylesheet"
		type="text/css"></link>
	<table width="100%" border="0" cellspacing="0" cellpadding="0"
		id="table_titlebar">
		<tr>
			<td align="left" valign="middle" class="vign-dialogTitlebar"
				width="90%" nowrap="nowrap"><div id="dialogTitle"
					class="vign-dialogTitleText">Make Script</div></td>
			<td class="vign-dialogTitlebarStretch"><img
				src="/AppConsole/common/images/dotclear.gif" height="43" width="1"></td>
		</tr>
	</table>
	<%
		String vcmPath = "";
		String vcmBin = "";
		String vcmUser = "";
		String vcmPasswd = "";
		String vcmServer = "";
		String vcmPort = "";
		String vcmLogDir = request.getParameter("generalLogDir").trim();
		String vcmVgnPackDir = request.getParameter("generalVgnPackDir").trim();

		String vcmExecute = " ";
		String fileName = "untitled";
		String label = "untitled";
		String nl = "\n\n\n";
	%>
	<table width="100%">
		<tr>
			<td width="100%">
				<h1>Export</h1> <textarea name="Export" rows="20" cols="150">
#! /bin/bash
if [ $# -ne 1 ]; then
echo "Input the <%=vcmUser%>'s password on parameter."
else
<%
	try {
		vcmBin = "vgnexport";
		vcmPath = request.getParameter("expExecPath").trim();
		vcmUser = request.getParameter("expUser").trim();
		vcmServer = request.getParameter("expHost").trim();
		vcmPort = request.getParameter("expPort").trim();
		vcmPasswd = "$1";

		vcmExecute = vcmPath + "/" + vcmBin + " -u " + vcmUser + " -p " + vcmPasswd + " -h " + vcmServer + ":"
				+ vcmPort;
		out.print("echo Projects\n\n");
		IPagingList ipl = Project.getRootProjects();
		IPagingList iplSub = null;
		IPagingList iplSub2 = null;
		List list = ipl.asList();
		List listSub = null;
		List listSub2 = null;
		Iterator iterator = list.iterator();
		Iterator iteratorSub = null;
		Iterator iteratorSub2 = null;
		while (iterator.hasNext()) {
			Project prj = (Project) iterator.next();
			if (!prj.getProjectData().getName().equals("System")) {
				fileName = "PRJ_" + prj.getProjectData().getName();
				fileName = unAccent(fileName);
				out.print("echo Project:" + fileName + "\n\n");
				out.print(vcmExecute + " -i " + prj.getProjectData().getId() + " -f " + vcmVgnPackDir + "/"
						+ fileName + ".zip -l " + vcmLogDir + "/exp_" + fileName
						+ ".log -c projectContent=false -c subProjects=false -c resultsLevel=all" + nl);
				iplSub = prj.getSubprojects();
				listSub = iplSub.asList();
				iteratorSub = listSub.iterator();
				while (iteratorSub.hasNext()) {
					Project prjSub = (Project) iteratorSub.next();
					fileName = "PRJ_" + prj.getProjectData().getName() + "@"
							+ prjSub.getProjectData().getName();
					fileName = unAccent(fileName);
					out.print("echo Project:" + fileName + "\n\n");
					out.print(vcmExecute + " -i " + prjSub.getProjectData().getId() + " -f " + vcmVgnPackDir
							+ "/" + fileName + ".zip -l " + vcmLogDir + "/exp_" + fileName
							+ ".log -c projectContent=false -c subProjects=false -c resultsLevel=all" + nl);
					iplSub2 = prjSub.getSubprojects();
					listSub2 = iplSub2.asList();
					iteratorSub2 = listSub2.iterator();
					while (iteratorSub2.hasNext()) {
						Project prjSub2 = (Project) iteratorSub2.next();
						fileName = "PRJ_" + prj.getProjectData().getName() + "@"
								+ prjSub.getProjectData().getName() + "@" + prjSub2.getProjectData().getName();
						fileName = unAccent(fileName);
						out.print("echo Project:" + fileName + "\n\n");
						out.print(vcmExecute + " -i " + prjSub2.getProjectData().getId() + " -f "
								+ vcmVgnPackDir + "/" + fileName + ".zip -l " + vcmLogDir + "/exp_" + fileName
								+ ".log -c projectContent=false -c resultsLevel=all" + nl);
					}
				}
			}
		}

		out.print("echo Content Types\n\n");
		Project project = Project.findProjectByPath("/System/AppSvcs/ObjectTypes/ContentType");
		ipl = project.getSubprojects();
		list = ipl.asList();
		iterator = list.iterator();
		while (iterator.hasNext()) {
			Project prj = (Project) iterator.next();
			fileName = "CTD_" + prj.getProjectData().getName();
			fileName = unAccent(fileName);
			out.print("echo Content Type:" + fileName + "\n\n");
			out.print(vcmExecute + " -i " + prj.getProjectData().getId() + " -f " + vcmVgnPackDir + "/"
					+ fileName + ".zip -l " + vcmLogDir + "/exp_" + fileName + ".log -c resultsLevel=all" + nl);
		}

		out.print("echo Contents\n\n");
		ipl = Project.getRootProjects();
		iplSub = null;
		list = ipl.asList();
		listSub = null;
		iterator = list.iterator();
		iteratorSub = null;
		while (iterator.hasNext()) {
			Project prj = (Project) iterator.next();
			if (!prj.getProjectData().getName().equals("System")) {
				fileName = "Content_" + prj.getProjectData().getName();
				fileName = unAccent(fileName);
				out.print("echo Content:" + fileName + "\n\n");
				out.print(vcmExecute + " -i " + prj.getProjectData().getId() + " -f " + vcmVgnPackDir + "/"
						+ fileName + ".zip -l " + vcmLogDir + "/exp_" + fileName
						+ ".log -c subProjects=false -c resultsLevel=all" + nl);
				iplSub = prj.getSubprojects();
				listSub = iplSub.asList();
				iteratorSub = listSub.iterator();
				while (iteratorSub.hasNext()) {
					Project prjSub = (Project) iteratorSub.next();
					fileName = "Content_" + prj.getProjectData().getName() + "@"
							+ prjSub.getProjectData().getName();
					fileName = unAccent(fileName);
					out.print("echo Content:" + fileName + "\n\n");
					out.print(vcmExecute + " -i " + prjSub.getProjectData().getId() + " -f " + vcmVgnPackDir
							+ "/" + fileName + ".zip -l " + vcmLogDir + "/exp_" + fileName
							+ ".log -c subProjects=false -c resultsLevel=all" + nl);
					iplSub2 = prjSub.getSubprojects();
					listSub2 = iplSub2.asList();
					iteratorSub2 = listSub2.iterator();
					while (iteratorSub2.hasNext()) {
						Project prjSub2 = (Project) iteratorSub2.next();
						fileName = "Content_" + prj.getProjectData().getName()
								+ prjSub.getProjectData().getName() + "@" + prjSub2.getProjectData().getName();
						fileName = unAccent(fileName);
						out.print("echo Content:" + fileName + "\n\n");
						out.print(vcmExecute + " -i " + prjSub2.getProjectData().getId() + " -f "
								+ vcmVgnPackDir + "/" + fileName + ".zip -l " + vcmLogDir + "/exp_" + fileName
								+ ".log -c resultsLevel=all" + nl);
					}
				}
			}
		}

		out.print("echo Channels\n\n");
		ipl = Site.findAll();
		list = ipl.asList();
		iterator = list.iterator();
		while (iterator.hasNext()) {
			Site s = (Site) iterator.next();
			fileName = "Channel_" + s.getData().getName();
			fileName = unAccent(fileName);
			out.print("echo Channel:" + fileName + "\n\n");
			out.print(vcmExecute + " -i " + s.getContentManagementId() + " -f " + vcmVgnPackDir + "/" + fileName
					+ ".zip -l " + vcmLogDir + "/exp_" + fileName
					+ ".log -c resultsLevel=all -c errorPolicy=continue" + nl);
		}

		out.print("echo Sites\n\n");
		ipl = Site.findAll();
		list = ipl.asList();
		iterator = list.iterator();
		while (iterator.hasNext()) {
			Site s = (Site) iterator.next();
			fileName = "Site_" + s.getData().getName();
			fileName = unAccent(fileName);
			out.print("echo Site:" + fileName + "\n\n");
			out.print(vcmExecute + " -i " + s.getContentManagementId() + " -f " + vcmVgnPackDir + "/" + fileName
					+ ".zip -l " + vcmLogDir + "/exp_" + fileName
					+ ".log -c resultsLevel=all -c errorPolicy=continue" + nl);
		}

	} catch (Exception _e) {
		out.println(_e.toString());
	}
%>
fi
echo Terminate

</textarea>
				<h1>Import</h1> <textarea name="Import" rows="20" cols="150">
#! /bin/bash
if [ $# -ne 1 ]; then
echo "Input the <%=vcmUser%>'s password on parameter."
else
<%
	try {
		vcmBin = "vgnimport";
		vcmPath = request.getParameter("impExecPath").trim();
		vcmUser = request.getParameter("impUser").trim();
		vcmServer = request.getParameter("impHost").trim();
		vcmPort = request.getParameter("impPort").trim();
		vcmPasswd = "$1";

		vcmExecute = vcmPath + "/" + vcmBin + " -u " + vcmUser + " -p " + vcmPasswd + " -h " + vcmServer + ":"
				+ vcmPort;
		out.print("echo Projects\n\n");
		IPagingList ipl = Project.getRootProjects();
		IPagingList iplSub = null;
		IPagingList iplSub2 = null;
		List list = ipl.asList();
		List listSub = null;
		List listSub2 = null;
		Iterator iterator = list.iterator();
		Iterator iteratorSub = null;
		Iterator iteratorSub2 = null;
		while (iterator.hasNext()) {
			Project prj = (Project) iterator.next();
			if (!prj.getProjectData().getName().equals("System")) {
				fileName = "PRJ_" + prj.getProjectData().getName();
				fileName = unAccent(fileName);
				out.print("echo Project:" + fileName + "\n\n");
				out.print(vcmExecute + " -f " + vcmVgnPackDir + "/" + fileName + ".zip -l " + vcmLogDir
						+ "/imp_" + fileName + ".log -c resultsLevel=all" + nl);
				iplSub = prj.getSubprojects();
				listSub = iplSub.asList();
				iteratorSub = listSub.iterator();
				while (iteratorSub.hasNext()) {
					Project prjSub = (Project) iteratorSub.next();
					fileName = "PRJ_" + prj.getProjectData().getName() + "@"
							+ prjSub.getProjectData().getName();
					fileName = unAccent(fileName);
					out.print("echo Project:" + fileName + "\n\n");
					out.print(vcmExecute + " -f " + vcmVgnPackDir + "/" + fileName + ".zip -l " + vcmLogDir
							+ "/imp_" + fileName + ".log -c resultsLevel=all" + nl);
					iplSub2 = prjSub.getSubprojects();
					listSub2 = iplSub2.asList();
					iteratorSub2 = listSub2.iterator();
					while (iteratorSub2.hasNext()) {
						Project prjSub2 = (Project) iteratorSub2.next();
						fileName = "PRJ_" + prj.getProjectData().getName() + "@"
								+ prjSub.getProjectData().getName() + "@" + prjSub2.getProjectData().getName();
						fileName = unAccent(fileName);
						out.print("echo Project:" + fileName + "\n\n");
						out.print(vcmExecute + " -f " + vcmVgnPackDir + "/" + fileName + ".zip -l " + vcmLogDir
								+ "/imp_" + fileName + ".log -c resultsLevel=all" + nl);
					}
				}
			}
		}

		out.print("echo Channels\n\n");
		ipl = Site.findAll();
		list = ipl.asList();
		iterator = list.iterator();
		while (iterator.hasNext()) {
			Site s = (Site) iterator.next();
			fileName = "Channel_" + s.getData().getName();
			fileName = unAccent(fileName);
			out.print("echo Channel:" + fileName + "\n\n");
			out.print(vcmExecute + " -f " + vcmVgnPackDir + "/" + fileName + ".zip -l " + vcmLogDir + "/imp_"
					+ fileName + ".log -c resultsLevel=all -c errorPolicy=continue" + nl);
		}

		out.print("echo Content Types\n\n");
		Project project = Project.findProjectByPath("/System/AppSvcs/ObjectTypes/ContentType");
		ipl = project.getSubprojects();
		list = ipl.asList();
		iterator = list.iterator();
		while (iterator.hasNext()) {
			Project prj = (Project) iterator.next();
			fileName = "CTD_" + prj.getProjectData().getName();
			fileName = unAccent(fileName);
			out.print("echo Content Type:" + fileName + "\n\n");
			out.print(vcmExecute + " -f " + vcmVgnPackDir + "/" + fileName + ".zip -l " + vcmLogDir + "/imp_"
					+ fileName + ".log -c resultsLevel=all -c errorPolicy=continue" + nl);
		}

		out.print("echo Contents\n\n");
		ipl = Project.getRootProjects();
		iplSub = null;
		list = ipl.asList();
		listSub = null;
		iterator = list.iterator();
		iteratorSub = null;
		while (iterator.hasNext()) {
			Project prj = (Project) iterator.next();
			if (!prj.getProjectData().getName().equals("System")) {
				fileName = "Content_" + prj.getProjectData().getName();
				fileName = unAccent(fileName);
				out.print("echo Content:" + fileName + "\n\n");
				out.print(vcmExecute + " -f " + vcmVgnPackDir + "/" + fileName + ".zip -l " + vcmLogDir
						+ "/imp_" + fileName + ".log -c resultsLevel=all" + nl);
				iplSub = prj.getSubprojects();
				listSub = iplSub.asList();
				iteratorSub = listSub.iterator();
				while (iteratorSub.hasNext()) {
					Project prjSub = (Project) iteratorSub.next();
					fileName = "Content_" + prj.getProjectData().getName() + "@"
							+ prjSub.getProjectData().getName();
					fileName = unAccent(fileName);
					out.print("echo Content:" + fileName + "\n\n");
					out.print(vcmExecute + prjSub.getProjectData().getId() + " -f " + vcmVgnPackDir + "/"
							+ fileName + ".zip -l " + vcmLogDir + "/imp_" + fileName
							+ ".log -c resultsLevel=all" + nl);
					iplSub2 = prjSub.getSubprojects();
					listSub2 = iplSub2.asList();
					iteratorSub2 = listSub2.iterator();
					while (iteratorSub2.hasNext()) {
						Project prjSub2 = (Project) iteratorSub2.next();
						fileName = "Content_" + prj.getProjectData().getName()
								+ prjSub.getProjectData().getName() + "@" + prjSub2.getProjectData().getName();
						fileName = unAccent(fileName);
						out.print("echo Content:" + fileName + "\n\n");
						out.print(vcmExecute + " -f " + vcmVgnPackDir + "/" + fileName + ".zip -l " + vcmLogDir
								+ "/imp_" + fileName + ".log -c resultsLevel=all" + nl);
					}
				}
			}
		}

		out.print("echo Sites\n\n");
		ipl = Site.findAll();
		list = ipl.asList();
		iterator = list.iterator();
		while (iterator.hasNext()) {
			Site s = (Site) iterator.next();
			fileName = "Site_" + s.getData().getName();
			fileName = unAccent(fileName);
			out.print("echo Site:" + fileName + "\n\n");
			out.print(vcmExecute + " -f " + vcmVgnPackDir + "/" + fileName + ".zip -l " + vcmLogDir + "/imp_"
					+ fileName + ".log -c resultsLevel=all -c errorPolicy=continue" + nl);
		}
	} catch (Exception _e) {
		out.println(_e.toString());
	}
%>
fi
echo Terminate

</textarea>

			</td>
		</tr>
	</table>
</body>
</html>
