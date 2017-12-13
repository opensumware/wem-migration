<html>
<head>
<title>Migration Tool</title>
<script type="text/javascript">
	var djConfig = {
		isDebug : true
	};
	djconfigMigrationdebugAtAllCosts = false;
</script>
<script type="text/javascript" src="org/dojotoolkit/dojo.js"></script>
<script type="text/javascript">
	dojo.require("dojo.widget.TabContainer");
	dojo.require("dojo.event.*");
	dojo.require("dojo.widget.LayoutContainer");
	dojo.require("dojo.widget.ContentPane");

	dojo.hostenv.writeIncludes();
</script>
<body>
	<form id="formMigration" method="post" action="pages/migration.jsp">
		<div id="mainTabContainer" dojoType="TabContainer"
			selectedChild="migrationTabContainer"
			style="width: 100%; height: 100%;">
			<!-- Begin Main -->


			<div id="migrationTabContainer" dojoType="TabContainer"
				labelPosition="left-h" label="Migration Tool">
				<!-- Begin Migration -->

				<div dojoType="ContentPane" label="Export" style="overflow: hidden;">
					<!-- Begin Export -->
					<table width="100%">
						<tr>
							<td>
								<fieldset>
									<legend>Export</legend>
									<fieldset>
										<legend>VCM Bin Path</legend>
										<input name="expExecPath" type="text"
											value="/appl/opentext/WEM/Content/8_1/bin" size="50" />
										i.e.: /appl/opentext/WEM/Content/8_1/bin
									</fieldset>
									<fieldset>
										<legend>Server</legend>
										<table width="100%" border="0">
											<tr>
												<td><fieldset>
														<legend>Hostname</legend>
														<input type="text" name="expHost" value="vgncorp" />
														i.e.: vgncorp

													</fieldset></td>
												<td>
													<fieldset>
														<legend>Port</legend>
														<input type="text" name="expPort" value="27110" /> i.e.:
														27110

													</fieldset>
												</td>
											</tr>
										</table>

									</fieldset>
									<fieldset>
										<legend>Authentication</legend>
										<table width="100%" border="0">
											<tr>
												<td><fieldset>
														<legend>Username</legend>
														<input type="text" name="expUser" value="vgnadmin" />
														i.e.: vgnadmin
													</fieldset></td>
											</tr>
										</table>

									</fieldset>
								</fieldset>
							</td>
						</tr>
					</table>
				</div>

				<div dojoType="ContentPane" label="Import" style="overflow: hidden;">
					<table width="100%">
						<tr>
							<td>
								<fieldset>
									<legend>Import</legend>
									<fieldset>
										<legend>VCM Bin Path</legend>
										<input name="impExecPath" type="text"
											value="/appl/opentext/WEM/Content/8_1/bin" size="50" />
										i.e.: /appl/opentext/WEM/Content/8_1/bin
									</fieldset>
									<fieldset>
										<legend>Server</legend>
										<table width="100%" border="0">
											<tr>
												<td><fieldset>
														<legend>Hostname</legend>
														<input type="text" name="impHost" value="vgncorp" />
														i.e.: vgncorp
													</fieldset></td>
												<td>
													<fieldset>
														<legend>Port</legend>
														<input type="text" name="impPort" value="27110" /> i.e.:
														27110
													</fieldset>
												</td>
											</tr>
										</table>

									</fieldset>
									<fieldset>
										<legend>Authentication</legend>
										<table width="100%" border="0">
											<tr>
												<td><fieldset>
														<legend>Username</legend>
														<input name="impUser" type="text" value="otadminprd1" />
														i.e.: otadmin
													</fieldset></td>
											</tr>
										</table>

									</fieldset>
								</fieldset>
							</td>
						</tr>
					</table>
				</div>
				<div dojoType="ContentPane" label="Make Script"
					style="overflow: hidden;">
					<table width="100%">
						<tr>
							<td>
								<fieldset>
									<legend>Make Script</legend>
									<fieldset>
										<legend>Directories</legend>
										<table width="100%" border="0">
											<tr>
												<td>
													<fieldset>
														<legend>Log Directory</legend>
														<input name="generalLogDir" type="text" value="logs" />
														i.e.: logs
													</fieldset>
												</td>
												<td><fieldset>
														<legend>VignettePack Directory</legend>
														<input name="generalVgnPackDir" type="text" value="packs" />
														i.e.: packs

													</fieldset></td>
											</tr>
											<tr>
												<td><input type="submit" name="submit"
													value="Make Script" /></td>
											</tr>
										</table>
									</fieldset>
								</fieldset>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</form>
</body>
</html>
