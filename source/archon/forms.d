module archon.forms;
import vibe.d;
import darklight.d;
import archon.arcbase;

void archonForms(alias Factory)(HttpServerRequest req, HttpServerResponse res)
{
	enum content = `
<StackPanel containerTag="body" extraAttr="data-spy='scroll' data-target='.bs-docs-sidebar' data-twttr-rendered='true'">
	<ArchonNav live="formnav"/>
	<StackPanel clss="jumbotron subhead" id="overview" containerTag="header">
		<StackPanel clss="container">
			<h1>Forms</h1>
			<p clss="lead">Certifications and codes.</p>
		</StackPanel>
	</StackPanel>
	<StackPanel clss="container">
		<StackPanel clss="row">
			<SideBar clss="span3">
				<SideBarItem link="#compliance">Certificate Compliance</SideBarItem>
				<SideBarItem link="#res-HVAC">Residential HVAC Alterations</SideBarItem>
				<SideBarItem link="#mandatory">Mandatory Measures</SideBarItem>
				<SideBarItem link="#worksheets">Worksheets</SideBarItem>
				<SideBarItem link="#cert-env">Installation Certificate</SideBarItem>
				<SideBarItem link="#cert-res">Installation Certificate - Residential</SideBarItem>
				<SideBarItem link="#cert-ltg">Installation Certificate - Lighting</SideBarItem>
				<SideBarItem link="#cert-mech">Installation Certificate - Mechanical</SideBarItem>
				<SideBarItem link="#cert-mech-res">Installation Certificate - Mechanical - Residential</SideBarItem>
			</SideBar>
			<StackPanel clss="span9">
				<Section id="compliance">
					<StackPanel clss="page-header">
						<h1>Certificate of Compliance - CF-1R</h1>
					</StackPanel>
					<HRef link="#">
						<h4>CF-1R - Certificate of Compliance: Residential New Construction</h4>
					</HRef>
					<HRef>
						<h4>CF-1R - ADD Certificate of Compliance: Residential Additions</h4>
					</HRef>
					<HRef>
						<h4>CF-1R - ALT Certificate of Compliance: Residential Alterations</h4>
					</HRef>
				</Section>
				<Section id="res-HVAC">
					<StackPanel clss="page-header">
						<h1>Residential HVAC Alterations CF-1R-ALT-HVAC</h1>
					</StackPanel>
					<HRef>
						<h4>Climate Zones 1 and 3 through 7</h4>
					</HRef>
					<HRef>
						<h4>Climate Zones 2, 9</h4>
					</HRef>
					<HRef>
						<h4>Climate Zones 8</h4>
					</HRef>
					<HRef>
						<h4>Climate Zones 10 to 15</h4>
					</HRef>
					<HRef>
						<h4>Climate Zones 16</h4>
					</HRef>
				</Section>
				<Section id="mandatory">
					<StackPanel clss="page-header">
						<h1>Mandatory Measures - MM</h1>
					</StackPanel>
					<HRef>
						<h4>MF-1R - Mandatory Measures Summary: Residential</h4>
					</HRef>
				</Section>
				<Section id="worksheets">
					<StackPanel clss="page-header">
						<h1>Worksheets - WS</h1>
					</StackPanel>
					<HRef>
						<h4>WS-1R - Thermal Mass Worksheet</h4>
					</HRef>
					<HRef>
						<h4>WS-2R - Area Weighted Average Calculation Worksheet</h4>
					</HRef>
					<HRef>
						<h4>WS-3R - Solar Heat Gain Coefficient (SHGC) Worksheet</h4>
					</HRef>
				</Section>
				<Section id="cert-env">
					<StackPanel clss="page-header">
						<h1>Installation Certificate - CF-6R-ENV</h1>
					</StackPanel>
					<HRef>
						<h4>CF-6R-ENV-01 - Envelope - Insulation; Roofing; Fenestration</h4>
					</HRef>
				</Section>
				<Section id="cert-res">
					<StackPanel clss="page-header">
						<h1>Installation Certificate - CF-6R-ENV-HERS</h1>
					</StackPanel>
					<HRef>
						<h4>CF-6R-ENV-20-HERS - Building Envelope Sealing</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-ENV-21-HERS - Quality Insulation Installation (QII) - Framing Stage Checklist</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-ENV-22-HERS - Quality Insulation Installation (QII) - Insulation Stage Checklist</h4>
					</HRef>
				</Section>
				<Section id="cert-ltg">
					<StackPanel clss="page-header">
						<h1>Installation Certificate - CF-6R-LTG</h1>
					</StackPanel>
					<HRef>
						<h4>CF-6R-LTG-01 - Residential Lighting</h4>
					</HRef>
				</Section>
				<Section id="cert-mech">
					<StackPanel clss="page-header">
						<h1>Installation Certificate - CF-6R-MECH</h1>
					</StackPanel>
					<HRef>
						<h4>CF-6R-MECH-01 - Domestic Hot Water (DHW)</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-MECH-02 - Solar Domestic Hot Water Systems (SDHW)</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-MECH-03 - Pool And Spa Heating Systems</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-MECH-04 - Space Conditioning Systems, Ducts and Fans</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-MECH-05 - Indoor Air Quality and Mechanical Ventilation</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-MECH-06 - Evaporatively Cooled Condensing Units</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-MECH-07 - Evaporative Coolers</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-MECH-08 - Ice Storage Air Conditioning (ISAC) Units</h4>
					</HRef>
				</Section>
				<Section id="cert-mech-res">
					<StackPanel clss="page-header">
						<h1>Installation Certificate - CF-6R-MECH-HERS</h1>
					</StackPanel>
					<HRef>
						<h4>CF-6R-MECH-20-HERS - Duct Leakage Test - Completely New or Replacement Duct System</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-MECH-21-HERS - Duct Leakage Test - Existing Duct System</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-MECH-22-HERS - HSPP/PSPP Installation; Cooling Coil Airflow & Fan Watt Draw Test</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-MECH-23-HERS - Verification of High EER Equipment</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-MECH-24-HERS - Charge Indicator Display (CID)</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-MECH-25-HERS - Refrigerant Charge Verification - Standard Measurement Procedure</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-MECH-26-HERS - Refrigerant Charge Verification - Alternate Measurement Procedure</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-MECH-27-HERS - Maximum Rated Total Cooling Capacity</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-MECH-28-HERS - Low Leakage Air Handler Verification</h4>
					</HRef>
					<HRef>
						<h4>CF-6R-MECH-29-HERS - Supply Duct Compliance Credits - Location; Surface Area; R-value</h4>
					</HRef>
				</Section>
			</StackPanel>
		</StackPanel>
	</StackPanel>
	<ArchonFooter/>
</StackPanel>`;
	
	string html = Factory.Extract!(content)("", "").toString();
	string site = makeSite("Archon Home Energy Solutions - News", html);
	res.writeBody(site, "text/html; charset=UTF-8");
}