<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE eagle SYSTEM "eagle.dtd">
<eagle version="7.5.0">
<drawing>
<settings>
<setting alwaysvectorfont="no"/>
<setting verticaltext="up"/>
</settings>
<grid distance="0.1" unitdist="inch" unit="inch" style="lines" multiple="1" display="no" altdistance="0.01" altunitdist="inch" altunit="inch"/>
<layers>
<layer number="1" name="Top" color="4" fill="1" visible="no" active="no"/>
<layer number="2" name="Route2" color="1" fill="3" visible="no" active="no"/>
<layer number="3" name="Route3" color="4" fill="3" visible="no" active="no"/>
<layer number="4" name="Route4" color="1" fill="4" visible="no" active="no"/>
<layer number="5" name="Route5" color="4" fill="4" visible="no" active="no"/>
<layer number="6" name="Route6" color="1" fill="8" visible="no" active="no"/>
<layer number="7" name="Route7" color="4" fill="8" visible="no" active="no"/>
<layer number="8" name="Route8" color="1" fill="2" visible="no" active="no"/>
<layer number="9" name="Route9" color="4" fill="2" visible="no" active="no"/>
<layer number="10" name="Route10" color="1" fill="7" visible="no" active="no"/>
<layer number="11" name="Route11" color="4" fill="7" visible="no" active="no"/>
<layer number="12" name="Route12" color="1" fill="5" visible="no" active="no"/>
<layer number="13" name="Route13" color="4" fill="5" visible="no" active="no"/>
<layer number="14" name="Route14" color="1" fill="6" visible="no" active="no"/>
<layer number="15" name="Route15" color="4" fill="6" visible="no" active="no"/>
<layer number="16" name="Bottom" color="1" fill="1" visible="no" active="no"/>
<layer number="17" name="Pads" color="2" fill="1" visible="no" active="no"/>
<layer number="18" name="Vias" color="2" fill="1" visible="no" active="no"/>
<layer number="19" name="Unrouted" color="6" fill="1" visible="no" active="no"/>
<layer number="20" name="Dimension" color="15" fill="1" visible="no" active="no"/>
<layer number="21" name="tPlace" color="7" fill="1" visible="no" active="no"/>
<layer number="22" name="bPlace" color="7" fill="1" visible="no" active="no"/>
<layer number="23" name="tOrigins" color="15" fill="1" visible="no" active="no"/>
<layer number="24" name="bOrigins" color="15" fill="1" visible="no" active="no"/>
<layer number="25" name="tNames" color="7" fill="1" visible="no" active="no"/>
<layer number="26" name="bNames" color="7" fill="1" visible="no" active="no"/>
<layer number="27" name="tValues" color="7" fill="1" visible="no" active="no"/>
<layer number="28" name="bValues" color="7" fill="1" visible="no" active="no"/>
<layer number="29" name="tStop" color="7" fill="3" visible="no" active="no"/>
<layer number="30" name="bStop" color="7" fill="6" visible="no" active="no"/>
<layer number="31" name="tCream" color="7" fill="4" visible="no" active="no"/>
<layer number="32" name="bCream" color="7" fill="5" visible="no" active="no"/>
<layer number="33" name="tFinish" color="6" fill="3" visible="no" active="no"/>
<layer number="34" name="bFinish" color="6" fill="6" visible="no" active="no"/>
<layer number="35" name="tGlue" color="7" fill="4" visible="no" active="no"/>
<layer number="36" name="bGlue" color="7" fill="5" visible="no" active="no"/>
<layer number="37" name="tTest" color="7" fill="1" visible="no" active="no"/>
<layer number="38" name="bTest" color="7" fill="1" visible="no" active="no"/>
<layer number="39" name="tKeepout" color="4" fill="11" visible="no" active="no"/>
<layer number="40" name="bKeepout" color="1" fill="11" visible="no" active="no"/>
<layer number="41" name="tRestrict" color="4" fill="10" visible="no" active="no"/>
<layer number="42" name="bRestrict" color="1" fill="10" visible="no" active="no"/>
<layer number="43" name="vRestrict" color="2" fill="10" visible="no" active="no"/>
<layer number="44" name="Drills" color="7" fill="1" visible="no" active="no"/>
<layer number="45" name="Holes" color="7" fill="1" visible="no" active="no"/>
<layer number="46" name="Milling" color="3" fill="1" visible="no" active="no"/>
<layer number="47" name="Measures" color="7" fill="1" visible="no" active="no"/>
<layer number="48" name="Document" color="7" fill="1" visible="no" active="no"/>
<layer number="49" name="Reference" color="7" fill="1" visible="no" active="no"/>
<layer number="51" name="tDocu" color="6" fill="1" visible="no" active="no"/>
<layer number="52" name="bDocu" color="7" fill="1" visible="no" active="no"/>
<layer number="90" name="Modules" color="5" fill="1" visible="yes" active="yes"/>
<layer number="91" name="Nets" color="2" fill="1" visible="yes" active="yes"/>
<layer number="92" name="Busses" color="1" fill="1" visible="yes" active="yes"/>
<layer number="93" name="Pins" color="2" fill="1" visible="no" active="yes"/>
<layer number="94" name="Symbols" color="4" fill="1" visible="yes" active="yes"/>
<layer number="95" name="Names" color="7" fill="1" visible="yes" active="yes"/>
<layer number="96" name="Values" color="7" fill="1" visible="yes" active="yes"/>
<layer number="97" name="Info" color="7" fill="1" visible="yes" active="yes"/>
<layer number="98" name="Guide" color="6" fill="1" visible="yes" active="yes"/>
<layer number="99" name="SpiceOrder" color="5" fill="1" visible="yes" active="yes"/>
</layers>
<schematic xreflabel="%F%N/%S.%C%R" xrefpart="/%S.%C%R">
<libraries>
<library name="supply1">
<description>&lt;b&gt;Supply Symbols&lt;/b&gt;&lt;p&gt;
 GND, VCC, 0V, +5V, -5V, etc.&lt;p&gt;
 Please keep in mind, that these devices are necessary for the
 automatic wiring of the supply signals.&lt;p&gt;
 The pin name defined in the symbol is identical to the net which is to be wired automatically.&lt;p&gt;
 In this library the device names are the same as the pin names of the symbols, therefore the correct signal names appear next to the supply symbols in the schematic.&lt;p&gt;
 &lt;author&gt;Created by librarian@cadsoft.de&lt;/author&gt;</description>
<packages>
</packages>
<symbols>
<symbol name="GND">
<wire x1="-1.905" y1="0" x2="1.905" y2="0" width="0.254" layer="94"/>
<text x="-2.54" y="-2.54" size="1.778" layer="96">&gt;VALUE</text>
<pin name="GND" x="0" y="2.54" visible="off" length="short" direction="sup" rot="R270"/>
</symbol>
<symbol name="V+">
<wire x1="0.889" y1="-1.27" x2="0" y2="0.127" width="0.254" layer="94"/>
<wire x1="0" y1="0.127" x2="-0.889" y2="-1.27" width="0.254" layer="94"/>
<wire x1="-0.889" y1="-1.27" x2="0.889" y2="-1.27" width="0.254" layer="94"/>
<text x="-2.54" y="-2.54" size="1.778" layer="96" rot="R90">&gt;VALUE</text>
<pin name="V+" x="0" y="-2.54" visible="off" length="short" direction="sup" rot="R90"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="GND" prefix="GND">
<description>&lt;b&gt;SUPPLY SYMBOL&lt;/b&gt;</description>
<gates>
<gate name="1" symbol="GND" x="0" y="0"/>
</gates>
<devices>
<device name="">
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="V+" prefix="P+">
<description>&lt;b&gt;SUPPLY SYMBOL&lt;/b&gt;</description>
<gates>
<gate name="1" symbol="V+" x="0" y="0"/>
</gates>
<devices>
<device name="">
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="opto-trans-siemens">
<description>&lt;b&gt;Siemens Opto Transistors&lt;/b&gt;&lt;p&gt;
&lt;author&gt;Created by librarian@cadsoft.de&lt;/author&gt;</description>
<packages>
<package name="BPX81">
<description>&lt;B&gt;PHOTO TRANSISTOR&lt;/B&gt;</description>
<wire x1="-1.27" y1="-1.27" x2="1.27" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="1.27" y1="1.27" x2="-1.27" y2="1.27" width="0.1524" layer="21"/>
<wire x1="1.27" y1="-1.27" x2="1.27" y2="-0.889" width="0.1524" layer="21"/>
<wire x1="1.27" y1="1.27" x2="1.27" y2="0.889" width="0.1524" layer="21"/>
<wire x1="1.27" y1="0.889" x2="1.27" y2="0.508" width="0.1524" layer="51"/>
<wire x1="-1.27" y1="1.27" x2="-1.27" y2="0.889" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="-1.27" x2="-1.27" y2="-0.889" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="-0.889" x2="-1.27" y2="0.889" width="0.1524" layer="51"/>
<wire x1="0" y1="1.27" x2="0.9917" y2="0.7934" width="0.1524" layer="21" curve="-51.33923"/>
<wire x1="-0.9917" y1="0.7934" x2="0" y2="1.27" width="0.1524" layer="21" curve="-51.33923"/>
<wire x1="0" y1="-1.27" x2="0.9917" y2="-0.7934" width="0.1524" layer="21" curve="51.33923"/>
<wire x1="-0.9917" y1="-0.7934" x2="0" y2="-1.27" width="0.1524" layer="21" curve="51.33923"/>
<wire x1="0.9558" y1="-0.8363" x2="1.27" y2="0" width="0.1524" layer="51" curve="41.185419"/>
<wire x1="0.9756" y1="0.813" x2="1.2699" y2="0" width="0.1524" layer="51" curve="-39.806332"/>
<wire x1="-1.27" y1="0" x2="-0.9643" y2="-0.8265" width="0.1524" layer="51" curve="40.600331"/>
<wire x1="-1.27" y1="0" x2="-0.9643" y2="0.8265" width="0.1524" layer="51" curve="-40.600331"/>
<wire x1="-0.889" y1="0" x2="0" y2="0.889" width="0.1524" layer="51" curve="-90"/>
<wire x1="-0.508" y1="0" x2="0" y2="0.508" width="0.1524" layer="51" curve="-90"/>
<wire x1="0" y1="-0.508" x2="0.508" y2="0" width="0.1524" layer="51" curve="90"/>
<wire x1="0" y1="-0.889" x2="0.889" y2="0" width="0.1524" layer="51" curve="90"/>
<wire x1="1.27" y1="-0.635" x2="1.524" y2="-0.635" width="0.1524" layer="51"/>
<wire x1="1.27" y1="-0.635" x2="1.27" y2="-0.889" width="0.1524" layer="51"/>
<wire x1="1.651" y1="-0.635" x2="1.651" y2="0.762" width="0.1524" layer="51"/>
<wire x1="1.651" y1="0.762" x2="1.524" y2="0.762" width="0.1524" layer="51"/>
<wire x1="1.524" y1="0.762" x2="1.524" y2="0.508" width="0.1524" layer="51"/>
<wire x1="1.524" y1="0.508" x2="1.27" y2="0.508" width="0.1524" layer="51"/>
<wire x1="1.27" y1="0.508" x2="1.27" y2="-0.635" width="0.1524" layer="51"/>
<wire x1="1.524" y1="0.508" x2="1.524" y2="-0.635" width="0.1524" layer="51"/>
<wire x1="1.524" y1="-0.635" x2="1.651" y2="-0.635" width="0.1524" layer="51"/>
<pad name="E" x="-1.27" y="0" drill="0.8128" shape="long" rot="R90"/>
<pad name="C" x="1.27" y="0" drill="0.8128" shape="long" rot="R90"/>
<text x="-1.8034" y="1.6002" size="1.27" layer="25" ratio="10">&gt;NAME</text>
<text x="-1.778" y="-2.8702" size="1.27" layer="27" ratio="10">&gt;VALUE</text>
</package>
</packages>
<symbols>
<symbol name="OT-NO">
<wire x1="-3.048" y1="-2.54" x2="-1.27" y2="-0.762" width="0.1524" layer="94"/>
<wire x1="-1.27" y1="-0.762" x2="-2.413" y2="-1.143" width="0.1524" layer="94"/>
<wire x1="-2.413" y1="-1.143" x2="-1.651" y2="-1.905" width="0.1524" layer="94"/>
<wire x1="-1.651" y1="-1.905" x2="-1.27" y2="-0.762" width="0.1524" layer="94"/>
<wire x1="-1.143" y1="1.143" x2="-2.286" y2="0.762" width="0.1524" layer="94"/>
<wire x1="-2.286" y1="0.762" x2="-1.524" y2="0" width="0.1524" layer="94"/>
<wire x1="-1.524" y1="0" x2="-1.143" y2="1.143" width="0.1524" layer="94"/>
<wire x1="-2.921" y1="-0.635" x2="-1.143" y2="1.143" width="0.1524" layer="94"/>
<wire x1="2.54" y1="2.54" x2="0" y2="0" width="0.1524" layer="94"/>
<wire x1="0" y1="0" x2="2.286" y2="-2.286" width="0.1524" layer="94"/>
<wire x1="1.778" y1="-1.016" x2="2.286" y2="-2.286" width="0.1524" layer="94"/>
<wire x1="2.286" y1="-2.286" x2="2.54" y2="-2.54" width="0.1524" layer="94"/>
<wire x1="2.286" y1="-2.286" x2="1.016" y2="-1.778" width="0.1524" layer="94"/>
<wire x1="1.016" y1="-1.778" x2="1.778" y2="-1.016" width="0.1524" layer="94"/>
<text x="5.08" y="2.54" size="1.778" layer="95">&gt;NAME</text>
<text x="5.08" y="0" size="1.778" layer="96">&gt;VALUE</text>
<rectangle x1="-0.381" y1="-2.54" x2="0.381" y2="2.54" layer="94"/>
<pin name="E" x="2.54" y="-5.08" visible="off" length="short" direction="pas" rot="R90"/>
<pin name="C" x="2.54" y="5.08" visible="off" length="short" direction="pas" rot="R270"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="BPX81" prefix="T">
<description>&lt;B&gt;PHOTO TRANSISTOR&lt;/B&gt;</description>
<gates>
<gate name="1" symbol="OT-NO" x="0" y="0"/>
</gates>
<devices>
<device name="" package="BPX81">
<connects>
<connect gate="1" pin="C" pad="C"/>
<connect gate="1" pin="E" pad="E"/>
</connects>
<technologies>
<technology name="">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="unknown" constant="no"/>
</technology>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="tcrt5000">
<packages>
<package name="TCRT5000">
<wire x1="4.445" y1="-2.159" x2="-3.175" y2="-2.159" width="0.127" layer="21"/>
<wire x1="-3.175" y1="-2.159" x2="-4.318" y2="-1.016" width="0.127" layer="21"/>
<wire x1="4.445" y1="2.159" x2="4.445" y2="-2.159" width="0.127" layer="21"/>
<wire x1="4.445" y1="2.159" x2="-3.175" y2="2.159" width="0.127" layer="21"/>
<wire x1="-3.175" y1="2.159" x2="-4.318" y2="1.016" width="0.127" layer="21"/>
<wire x1="-4.318" y1="-1.016" x2="-4.318" y2="1.016" width="0.127" layer="21"/>
<circle x="4.318" y="2.032" radius="0.1796" width="0.254" layer="21"/>
<circle x="0.254" y="2.032" radius="0.5236" width="0.254" layer="21"/>
<circle x="0.254" y="-2.032" radius="0.5236" width="0.254" layer="21"/>
<pad name="K" x="-2.54" y="1.27" drill="0.8" shape="octagon" rot="R90"/>
<pad name="E" x="2.54" y="1.27" drill="0.8" shape="octagon" rot="R90"/>
<pad name="A" x="-2.54" y="-1.27" drill="0.8" shape="octagon" rot="R90"/>
<pad name="C" x="2.54" y="-1.27" drill="0.8" shape="octagon" rot="R90"/>
<text x="-5.08" y="-2.54" size="1.27" layer="21" rot="R90">&gt;NAME</text>
<text x="6.35" y="-2.54" size="1.27" layer="21" rot="R90">&gt;VALUE</text>
</package>
</packages>
<symbols>
<symbol name="OPTICAL_SENSOR">
<wire x1="-2.413" y1="-2.413" x2="-1.016" y2="-1.016" width="0.1524" layer="94"/>
<wire x1="-1.016" y1="-1.016" x2="-1.905" y2="-1.397" width="0.1524" layer="94"/>
<wire x1="-1.905" y1="-1.397" x2="-1.397" y2="-1.905" width="0.1524" layer="94"/>
<wire x1="-1.397" y1="-1.905" x2="-1.016" y2="-1.016" width="0.1524" layer="94"/>
<wire x1="-1.143" y1="0.127" x2="-2.032" y2="-0.254" width="0.1524" layer="94"/>
<wire x1="-2.032" y1="-0.254" x2="-1.524" y2="-0.762" width="0.1524" layer="94"/>
<wire x1="-1.524" y1="-0.762" x2="-1.143" y2="0.127" width="0.1524" layer="94"/>
<wire x1="-2.54" y1="-1.27" x2="-1.143" y2="0.127" width="0.1524" layer="94"/>
<wire x1="-3.175" y1="0" x2="-4.445" y2="-2.54" width="0.254" layer="94"/>
<wire x1="-4.445" y1="-2.54" x2="-5.715" y2="0" width="0.254" layer="94"/>
<wire x1="-3.175" y1="-2.54" x2="-4.445" y2="-2.54" width="0.254" layer="94"/>
<wire x1="-4.445" y1="-2.54" x2="-5.715" y2="-2.54" width="0.254" layer="94"/>
<wire x1="-3.175" y1="0" x2="-4.445" y2="0" width="0.254" layer="94"/>
<wire x1="-4.445" y1="0" x2="-4.445" y2="-2.54" width="0.254" layer="94"/>
<wire x1="-4.445" y1="0" x2="-5.715" y2="0" width="0.254" layer="94"/>
<wire x1="-6.985" y1="-7.62" x2="4.445" y2="-7.62" width="0.4064" layer="94"/>
<wire x1="-6.985" y1="5.08" x2="-6.985" y2="-7.62" width="0.4064" layer="94"/>
<wire x1="4.445" y1="5.08" x2="4.445" y2="-7.62" width="0.4064" layer="94"/>
<wire x1="-7.62" y1="2.54" x2="-4.445" y2="2.54" width="0.1524" layer="94"/>
<wire x1="-4.445" y1="2.54" x2="-4.445" y2="0" width="0.1524" layer="94"/>
<wire x1="-4.445" y1="-2.54" x2="-4.445" y2="-5.08" width="0.1524" layer="94"/>
<wire x1="-4.445" y1="-5.08" x2="-7.62" y2="-5.08" width="0.1524" layer="94"/>
<wire x1="-6.985" y1="5.08" x2="4.445" y2="5.08" width="0.4064" layer="94"/>
<wire x1="2.54" y1="1.016" x2="0.508" y2="-1.016" width="0.1524" layer="94"/>
<wire x1="0.508" y1="-1.016" x2="2.54" y2="-3.81" width="0.1524" layer="94"/>
<wire x1="2.286" y1="-2.286" x2="2.54" y2="-3.81" width="0.1524" layer="94"/>
<wire x1="2.54" y1="-3.81" x2="1.27" y2="-3.048" width="0.1524" layer="94"/>
<wire x1="1.27" y1="-3.048" x2="2.286" y2="-2.286" width="0.1524" layer="94"/>
<wire x1="2.54" y1="2.54" x2="5.08" y2="2.54" width="0.1524" layer="94"/>
<wire x1="2.54" y1="2.54" x2="2.54" y2="1.016" width="0.1524" layer="94"/>
<wire x1="2.54" y1="-3.81" x2="2.54" y2="-5.08" width="0.1524" layer="94"/>
<wire x1="2.54" y1="-5.08" x2="5.08" y2="-5.08" width="0.1524" layer="94"/>
<text x="-6.985" y="5.715" size="1.778" layer="95">&gt;NAME</text>
<text x="-6.985" y="-10.16" size="1.778" layer="96">&gt;VALUE</text>
<rectangle x1="-0.127" y1="-3.81" x2="0.635" y2="1.27" layer="94"/>
<pin name="ANODE" x="-10.16" y="2.54" visible="pad" length="short" direction="pas"/>
<pin name="COLLECTOR" x="7.62" y="2.54" visible="pad" length="short" direction="pas" rot="R180"/>
<pin name="CATHODE" x="-10.16" y="-5.08" visible="pad" length="short" direction="pas"/>
<pin name="EMITTER" x="7.62" y="-5.08" visible="pad" length="short" direction="pas" rot="R180"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="TCRT5000" prefix="OS" uservalue="yes">
<gates>
<gate name="OS" symbol="OPTICAL_SENSOR" x="-7.62" y="7.62"/>
</gates>
<devices>
<device name="" package="TCRT5000">
<connects>
<connect gate="OS" pin="ANODE" pad="A"/>
<connect gate="OS" pin="CATHODE" pad="K"/>
<connect gate="OS" pin="COLLECTOR" pad="C"/>
<connect gate="OS" pin="EMITTER" pad="E"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="pinhead">
<description>&lt;b&gt;Pin Header Connectors&lt;/b&gt;&lt;p&gt;
&lt;author&gt;Created by librarian@cadsoft.de&lt;/author&gt;</description>
<packages>
<package name="1X04">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<wire x1="0" y1="0.635" x2="0.635" y2="1.27" width="0.1524" layer="21"/>
<wire x1="0.635" y1="1.27" x2="1.905" y2="1.27" width="0.1524" layer="21"/>
<wire x1="1.905" y1="1.27" x2="2.54" y2="0.635" width="0.1524" layer="21"/>
<wire x1="2.54" y1="0.635" x2="2.54" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="2.54" y1="-0.635" x2="1.905" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="1.905" y1="-1.27" x2="0.635" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="0.635" y1="-1.27" x2="0" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="-4.445" y1="1.27" x2="-3.175" y2="1.27" width="0.1524" layer="21"/>
<wire x1="-3.175" y1="1.27" x2="-2.54" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="0.635" x2="-2.54" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="-0.635" x2="-3.175" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="0.635" x2="-1.905" y2="1.27" width="0.1524" layer="21"/>
<wire x1="-1.905" y1="1.27" x2="-0.635" y2="1.27" width="0.1524" layer="21"/>
<wire x1="-0.635" y1="1.27" x2="0" y2="0.635" width="0.1524" layer="21"/>
<wire x1="0" y1="0.635" x2="0" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="0" y1="-0.635" x2="-0.635" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-0.635" y1="-1.27" x2="-1.905" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-1.905" y1="-1.27" x2="-2.54" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="-5.08" y1="0.635" x2="-5.08" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="-4.445" y1="1.27" x2="-5.08" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-5.08" y1="-0.635" x2="-4.445" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-3.175" y1="-1.27" x2="-4.445" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="3.175" y1="1.27" x2="4.445" y2="1.27" width="0.1524" layer="21"/>
<wire x1="4.445" y1="1.27" x2="5.08" y2="0.635" width="0.1524" layer="21"/>
<wire x1="5.08" y1="0.635" x2="5.08" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="5.08" y1="-0.635" x2="4.445" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="3.175" y1="1.27" x2="2.54" y2="0.635" width="0.1524" layer="21"/>
<wire x1="2.54" y1="-0.635" x2="3.175" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="4.445" y1="-1.27" x2="3.175" y2="-1.27" width="0.1524" layer="21"/>
<pad name="1" x="-3.81" y="0" drill="1.016" shape="long" rot="R90"/>
<pad name="2" x="-1.27" y="0" drill="1.016" shape="long" rot="R90"/>
<pad name="3" x="1.27" y="0" drill="1.016" shape="long" rot="R90"/>
<pad name="4" x="3.81" y="0" drill="1.016" shape="long" rot="R90"/>
<text x="-5.1562" y="1.8288" size="1.27" layer="25" ratio="10">&gt;NAME</text>
<text x="-5.08" y="-3.175" size="1.27" layer="27">&gt;VALUE</text>
<rectangle x1="1.016" y1="-0.254" x2="1.524" y2="0.254" layer="51"/>
<rectangle x1="-1.524" y1="-0.254" x2="-1.016" y2="0.254" layer="51"/>
<rectangle x1="-4.064" y1="-0.254" x2="-3.556" y2="0.254" layer="51"/>
<rectangle x1="3.556" y1="-0.254" x2="4.064" y2="0.254" layer="51"/>
</package>
<package name="1X05">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<wire x1="1.905" y1="1.27" x2="3.175" y2="1.27" width="0.1524" layer="21"/>
<wire x1="3.175" y1="1.27" x2="3.81" y2="0.635" width="0.1524" layer="21"/>
<wire x1="3.81" y1="0.635" x2="3.81" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="3.81" y1="-0.635" x2="3.175" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="0.635" x2="-0.635" y2="1.27" width="0.1524" layer="21"/>
<wire x1="-0.635" y1="1.27" x2="0.635" y2="1.27" width="0.1524" layer="21"/>
<wire x1="0.635" y1="1.27" x2="1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="1.27" y1="0.635" x2="1.27" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="1.27" y1="-0.635" x2="0.635" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="0.635" y1="-1.27" x2="-0.635" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-0.635" y1="-1.27" x2="-1.27" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="1.905" y1="1.27" x2="1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="1.27" y1="-0.635" x2="1.905" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="3.175" y1="-1.27" x2="1.905" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-5.715" y1="1.27" x2="-4.445" y2="1.27" width="0.1524" layer="21"/>
<wire x1="-4.445" y1="1.27" x2="-3.81" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="0.635" x2="-3.81" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="-0.635" x2="-4.445" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="0.635" x2="-3.175" y2="1.27" width="0.1524" layer="21"/>
<wire x1="-3.175" y1="1.27" x2="-1.905" y2="1.27" width="0.1524" layer="21"/>
<wire x1="-1.905" y1="1.27" x2="-1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="0.635" x2="-1.27" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="-0.635" x2="-1.905" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-1.905" y1="-1.27" x2="-3.175" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-3.175" y1="-1.27" x2="-3.81" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="-6.35" y1="0.635" x2="-6.35" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="-5.715" y1="1.27" x2="-6.35" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-6.35" y1="-0.635" x2="-5.715" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="-4.445" y1="-1.27" x2="-5.715" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="4.445" y1="1.27" x2="5.715" y2="1.27" width="0.1524" layer="21"/>
<wire x1="5.715" y1="1.27" x2="6.35" y2="0.635" width="0.1524" layer="21"/>
<wire x1="6.35" y1="0.635" x2="6.35" y2="-0.635" width="0.1524" layer="21"/>
<wire x1="6.35" y1="-0.635" x2="5.715" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="4.445" y1="1.27" x2="3.81" y2="0.635" width="0.1524" layer="21"/>
<wire x1="3.81" y1="-0.635" x2="4.445" y2="-1.27" width="0.1524" layer="21"/>
<wire x1="5.715" y1="-1.27" x2="4.445" y2="-1.27" width="0.1524" layer="21"/>
<pad name="1" x="-5.08" y="0" drill="1.016" shape="long" rot="R90"/>
<pad name="2" x="-2.54" y="0" drill="1.016" shape="long" rot="R90"/>
<pad name="3" x="0" y="0" drill="1.016" shape="long" rot="R90"/>
<pad name="4" x="2.54" y="0" drill="1.016" shape="long" rot="R90"/>
<pad name="5" x="5.08" y="0" drill="1.016" shape="long" rot="R90"/>
<text x="-6.4262" y="1.8288" size="1.27" layer="25" ratio="10">&gt;NAME</text>
<text x="-6.35" y="-3.175" size="1.27" layer="27">&gt;VALUE</text>
<rectangle x1="2.286" y1="-0.254" x2="2.794" y2="0.254" layer="51"/>
<rectangle x1="-0.254" y1="-0.254" x2="0.254" y2="0.254" layer="51"/>
<rectangle x1="-2.794" y1="-0.254" x2="-2.286" y2="0.254" layer="51"/>
<rectangle x1="-5.334" y1="-0.254" x2="-4.826" y2="0.254" layer="51"/>
<rectangle x1="4.826" y1="-0.254" x2="5.334" y2="0.254" layer="51"/>
</package>
<package name="1X05/90">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<wire x1="-6.35" y1="-1.905" x2="-3.81" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="-1.905" x2="-3.81" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="0.635" x2="-6.35" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-6.35" y1="0.635" x2="-6.35" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-5.08" y1="6.985" x2="-5.08" y2="1.27" width="0.762" layer="21"/>
<wire x1="-3.81" y1="-1.905" x2="-1.27" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="-1.905" x2="-1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="0.635" x2="-3.81" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="6.985" x2="-2.54" y2="1.27" width="0.762" layer="21"/>
<wire x1="-1.27" y1="-1.905" x2="1.27" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="1.27" y1="-1.905" x2="1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="1.27" y1="0.635" x2="-1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="0" y1="6.985" x2="0" y2="1.27" width="0.762" layer="21"/>
<wire x1="1.27" y1="-1.905" x2="3.81" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="3.81" y1="-1.905" x2="3.81" y2="0.635" width="0.1524" layer="21"/>
<wire x1="3.81" y1="0.635" x2="1.27" y2="0.635" width="0.1524" layer="21"/>
<wire x1="2.54" y1="6.985" x2="2.54" y2="1.27" width="0.762" layer="21"/>
<wire x1="3.81" y1="-1.905" x2="6.35" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="6.35" y1="-1.905" x2="6.35" y2="0.635" width="0.1524" layer="21"/>
<wire x1="6.35" y1="0.635" x2="3.81" y2="0.635" width="0.1524" layer="21"/>
<wire x1="5.08" y1="6.985" x2="5.08" y2="1.27" width="0.762" layer="21"/>
<pad name="1" x="-5.08" y="-3.81" drill="1.016" shape="long" rot="R90"/>
<pad name="2" x="-2.54" y="-3.81" drill="1.016" shape="long" rot="R90"/>
<pad name="3" x="0" y="-3.81" drill="1.016" shape="long" rot="R90"/>
<pad name="4" x="2.54" y="-3.81" drill="1.016" shape="long" rot="R90"/>
<pad name="5" x="5.08" y="-3.81" drill="1.016" shape="long" rot="R90"/>
<text x="-6.985" y="-3.81" size="1.27" layer="25" ratio="10" rot="R90">&gt;NAME</text>
<text x="8.255" y="-3.81" size="1.27" layer="27" rot="R90">&gt;VALUE</text>
<rectangle x1="-5.461" y1="0.635" x2="-4.699" y2="1.143" layer="21"/>
<rectangle x1="-2.921" y1="0.635" x2="-2.159" y2="1.143" layer="21"/>
<rectangle x1="-0.381" y1="0.635" x2="0.381" y2="1.143" layer="21"/>
<rectangle x1="2.159" y1="0.635" x2="2.921" y2="1.143" layer="21"/>
<rectangle x1="4.699" y1="0.635" x2="5.461" y2="1.143" layer="21"/>
<rectangle x1="-5.461" y1="-2.921" x2="-4.699" y2="-1.905" layer="21"/>
<rectangle x1="-2.921" y1="-2.921" x2="-2.159" y2="-1.905" layer="21"/>
<rectangle x1="-0.381" y1="-2.921" x2="0.381" y2="-1.905" layer="21"/>
<rectangle x1="2.159" y1="-2.921" x2="2.921" y2="-1.905" layer="21"/>
<rectangle x1="4.699" y1="-2.921" x2="5.461" y2="-1.905" layer="21"/>
</package>
<package name="1_05X2MM">
<description>CON-M-1X5-200</description>
<text x="-4.5" y="1.5" size="1.27" layer="25" ratio="10">&gt;NAME</text>
<text x="-4.75" y="-2.75" size="1.27" layer="27">&gt;VALUE</text>
<wire x1="-5" y1="0.5" x2="-4.5" y2="1" width="0.1524" layer="21"/>
<wire x1="-4.5" y1="1" x2="-3.5" y2="1" width="0.1524" layer="21"/>
<wire x1="-3.5" y1="1" x2="-3" y2="0.5" width="0.1524" layer="21"/>
<wire x1="-3" y1="-0.5" x2="-3.5" y2="-1" width="0.1524" layer="21"/>
<wire x1="-3.5" y1="-1" x2="-4.5" y2="-1" width="0.1524" layer="21"/>
<wire x1="-4.5" y1="-1" x2="-5" y2="-0.5" width="0.1524" layer="21"/>
<wire x1="-5" y1="0.5" x2="-5" y2="-0.5" width="0.1524" layer="21"/>
<pad name="1" x="-4" y="0" drill="1.016" diameter="1.3" shape="square" rot="R90"/>
<rectangle x1="-4.254" y1="-0.254" x2="-3.746" y2="0.254" layer="51"/>
<wire x1="-3" y1="0.5" x2="-2.5" y2="1" width="0.1524" layer="21"/>
<wire x1="-2.5" y1="1" x2="-1.5" y2="1" width="0.1524" layer="21"/>
<wire x1="-1.5" y1="1" x2="-1" y2="0.5" width="0.1524" layer="21"/>
<wire x1="-1" y1="-0.5" x2="-1.5" y2="-1" width="0.1524" layer="21"/>
<wire x1="-1.5" y1="-1" x2="-2.5" y2="-1" width="0.1524" layer="21"/>
<wire x1="-2.5" y1="-1" x2="-3" y2="-0.5" width="0.1524" layer="21"/>
<wire x1="-3" y1="0.5" x2="-3" y2="-0.5" width="0.1524" layer="21"/>
<pad name="3" x="-2" y="0" drill="1.016" diameter="1.3" rot="R90"/>
<rectangle x1="-2.254" y1="-0.254" x2="-1.746" y2="0.254" layer="51"/>
<wire x1="-1" y1="0.5" x2="-0.5" y2="1" width="0.1524" layer="21"/>
<wire x1="-0.5" y1="1" x2="0.5" y2="1" width="0.1524" layer="21"/>
<wire x1="0.5" y1="1" x2="1" y2="0.5" width="0.1524" layer="21"/>
<wire x1="1" y1="-0.5" x2="0.5" y2="-1" width="0.1524" layer="21"/>
<wire x1="0.5" y1="-1" x2="-0.5" y2="-1" width="0.1524" layer="21"/>
<wire x1="-0.5" y1="-1" x2="-1" y2="-0.5" width="0.1524" layer="21"/>
<wire x1="-1" y1="0.5" x2="-1" y2="-0.5" width="0.1524" layer="21"/>
<pad name="2" x="0" y="0" drill="1.016" diameter="1.3" rot="R90"/>
<rectangle x1="-0.254" y1="-0.254" x2="0.254" y2="0.254" layer="51"/>
<wire x1="1" y1="0.5" x2="1.5" y2="1" width="0.1524" layer="21"/>
<wire x1="1.5" y1="1" x2="2.5" y2="1" width="0.1524" layer="21"/>
<wire x1="2.5" y1="1" x2="3" y2="0.5" width="0.1524" layer="21"/>
<wire x1="3" y1="-0.5" x2="2.5" y2="-1" width="0.1524" layer="21"/>
<wire x1="2.5" y1="-1" x2="1.5" y2="-1" width="0.1524" layer="21"/>
<wire x1="1.5" y1="-1" x2="1" y2="-0.5" width="0.1524" layer="21"/>
<wire x1="1" y1="0.5" x2="1" y2="-0.5" width="0.1524" layer="21"/>
<pad name="4" x="2" y="0" drill="1.016" diameter="1.3" rot="R90"/>
<rectangle x1="1.746" y1="-0.254" x2="2.254" y2="0.254" layer="51"/>
<wire x1="3" y1="0.5" x2="3.5" y2="1" width="0.1524" layer="21"/>
<wire x1="3.5" y1="1" x2="4.5" y2="1" width="0.1524" layer="21"/>
<wire x1="4.5" y1="1" x2="5" y2="0.5" width="0.1524" layer="21"/>
<wire x1="5" y1="0.5" x2="5" y2="-0.5" width="0.1524" layer="21"/>
<wire x1="5" y1="-0.5" x2="4.5" y2="-1" width="0.1524" layer="21"/>
<wire x1="4.5" y1="-1" x2="3.5" y2="-1" width="0.1524" layer="21"/>
<wire x1="3.5" y1="-1" x2="3" y2="-0.5" width="0.1524" layer="21"/>
<wire x1="3" y1="0.5" x2="3" y2="-0.5" width="0.1524" layer="21"/>
<pad name="5" x="4" y="0" drill="1.016" diameter="1.3" rot="R90"/>
<rectangle x1="3.746" y1="-0.254" x2="4.254" y2="0.254" layer="51"/>
</package>
<package name="1X04/90">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<wire x1="-5.08" y1="-1.905" x2="-2.54" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="-1.905" x2="-2.54" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="0.635" x2="-5.08" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-5.08" y1="0.635" x2="-5.08" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="6.985" x2="-3.81" y2="1.27" width="0.762" layer="21"/>
<wire x1="-2.54" y1="-1.905" x2="0" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="0" y1="-1.905" x2="0" y2="0.635" width="0.1524" layer="21"/>
<wire x1="0" y1="0.635" x2="-2.54" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="6.985" x2="-1.27" y2="1.27" width="0.762" layer="21"/>
<wire x1="0" y1="-1.905" x2="2.54" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="2.54" y1="-1.905" x2="2.54" y2="0.635" width="0.1524" layer="21"/>
<wire x1="2.54" y1="0.635" x2="0" y2="0.635" width="0.1524" layer="21"/>
<wire x1="1.27" y1="6.985" x2="1.27" y2="1.27" width="0.762" layer="21"/>
<wire x1="2.54" y1="-1.905" x2="5.08" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="5.08" y1="-1.905" x2="5.08" y2="0.635" width="0.1524" layer="21"/>
<wire x1="5.08" y1="0.635" x2="2.54" y2="0.635" width="0.1524" layer="21"/>
<wire x1="3.81" y1="6.985" x2="3.81" y2="1.27" width="0.762" layer="21"/>
<pad name="1" x="-3.81" y="-3.81" drill="1.016" shape="long" rot="R90"/>
<pad name="2" x="-1.27" y="-3.81" drill="1.016" shape="long" rot="R90"/>
<pad name="3" x="1.27" y="-3.81" drill="1.016" shape="long" rot="R90"/>
<pad name="4" x="3.81" y="-3.81" drill="1.016" shape="long" rot="R90"/>
<text x="-5.715" y="-3.81" size="1.27" layer="25" ratio="10" rot="R90">&gt;NAME</text>
<text x="6.985" y="-4.445" size="1.27" layer="27" rot="R90">&gt;VALUE</text>
<rectangle x1="-4.191" y1="0.635" x2="-3.429" y2="1.143" layer="21"/>
<rectangle x1="-1.651" y1="0.635" x2="-0.889" y2="1.143" layer="21"/>
<rectangle x1="0.889" y1="0.635" x2="1.651" y2="1.143" layer="21"/>
<rectangle x1="3.429" y1="0.635" x2="4.191" y2="1.143" layer="21"/>
<rectangle x1="-4.191" y1="-2.921" x2="-3.429" y2="-1.905" layer="21"/>
<rectangle x1="-1.651" y1="-2.921" x2="-0.889" y2="-1.905" layer="21"/>
<rectangle x1="0.889" y1="-2.921" x2="1.651" y2="-1.905" layer="21"/>
<rectangle x1="3.429" y1="-2.921" x2="4.191" y2="-1.905" layer="21"/>
</package>
</packages>
<symbols>
<symbol name="PINHD4">
<wire x1="-6.35" y1="-5.08" x2="1.27" y2="-5.08" width="0.4064" layer="94"/>
<wire x1="1.27" y1="-5.08" x2="1.27" y2="7.62" width="0.4064" layer="94"/>
<wire x1="1.27" y1="7.62" x2="-6.35" y2="7.62" width="0.4064" layer="94"/>
<wire x1="-6.35" y1="7.62" x2="-6.35" y2="-5.08" width="0.4064" layer="94"/>
<text x="-6.35" y="8.255" size="1.778" layer="95">&gt;NAME</text>
<text x="-6.35" y="-7.62" size="1.778" layer="96">&gt;VALUE</text>
<pin name="1" x="-2.54" y="5.08" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="2" x="-2.54" y="2.54" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="3" x="-2.54" y="0" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="4" x="-2.54" y="-2.54" visible="pad" length="short" direction="pas" function="dot"/>
</symbol>
<symbol name="PINHD5">
<wire x1="-6.35" y1="-7.62" x2="1.27" y2="-7.62" width="0.4064" layer="94"/>
<wire x1="1.27" y1="-7.62" x2="1.27" y2="7.62" width="0.4064" layer="94"/>
<wire x1="1.27" y1="7.62" x2="-6.35" y2="7.62" width="0.4064" layer="94"/>
<wire x1="-6.35" y1="7.62" x2="-6.35" y2="-7.62" width="0.4064" layer="94"/>
<text x="-6.35" y="8.255" size="1.778" layer="95">&gt;NAME</text>
<text x="-6.35" y="-10.16" size="1.778" layer="96">&gt;VALUE</text>
<pin name="1" x="-2.54" y="5.08" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="2" x="-2.54" y="2.54" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="3" x="-2.54" y="0" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="4" x="-2.54" y="-2.54" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="5" x="-2.54" y="-5.08" visible="pad" length="short" direction="pas" function="dot"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="PINHD-1X4" prefix="JP" uservalue="yes">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<gates>
<gate name="A" symbol="PINHD4" x="0" y="0"/>
</gates>
<devices>
<device name="" package="1X04">
<connects>
<connect gate="A" pin="1" pad="1"/>
<connect gate="A" pin="2" pad="2"/>
<connect gate="A" pin="3" pad="3"/>
<connect gate="A" pin="4" pad="4"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="/90" package="1X04/90">
<connects>
<connect gate="A" pin="1" pad="1"/>
<connect gate="A" pin="2" pad="2"/>
<connect gate="A" pin="3" pad="3"/>
<connect gate="A" pin="4" pad="4"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
<deviceset name="PINHD-1X5" prefix="JP" uservalue="yes">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<gates>
<gate name="A" symbol="PINHD5" x="0" y="0"/>
</gates>
<devices>
<device name="" package="1X05">
<connects>
<connect gate="A" pin="1" pad="1"/>
<connect gate="A" pin="2" pad="2"/>
<connect gate="A" pin="3" pad="3"/>
<connect gate="A" pin="4" pad="4"/>
<connect gate="A" pin="5" pad="5"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="/90" package="1X05/90">
<connects>
<connect gate="A" pin="1" pad="1"/>
<connect gate="A" pin="2" pad="2"/>
<connect gate="A" pin="3" pad="3"/>
<connect gate="A" pin="4" pad="4"/>
<connect gate="A" pin="5" pad="5"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="5X2MM" package="1_05X2MM">
<connects>
<connect gate="A" pin="1" pad="1"/>
<connect gate="A" pin="2" pad="2"/>
<connect gate="A" pin="3" pad="3"/>
<connect gate="A" pin="4" pad="4"/>
<connect gate="A" pin="5" pad="5"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
</libraries>
<attributes>
</attributes>
<variantdefs>
</variantdefs>
<classes>
<class number="0" name="default" width="0" drill="0">
</class>
</classes>
<parts>
<part name="GND1" library="supply1" deviceset="GND" device=""/>
<part name="P+3" library="supply1" deviceset="V+" device=""/>
<part name="SENSOR1" library="opto-trans-siemens" deviceset="BPX81" device="" value="SENSOR1"/>
<part name="SENSOR2" library="opto-trans-siemens" deviceset="BPX81" device="" value="SENSOR2"/>
<part name="SENSOR3" library="opto-trans-siemens" deviceset="BPX81" device="" value="SENSOR3"/>
<part name="SENSOR5" library="opto-trans-siemens" deviceset="BPX81" device="" value="SENSOR5"/>
<part name="SENSOR4" library="opto-trans-siemens" deviceset="BPX81" device="" value="SENSOR4"/>
<part name="SENSOR6" library="opto-trans-siemens" deviceset="BPX81" device="" value="SENSOR6"/>
<part name="SENSOR7" library="opto-trans-siemens" deviceset="BPX81" device="" value="SENSOR7"/>
<part name="SENSOR8" library="opto-trans-siemens" deviceset="BPX81" device="" value="SENSOR8"/>
<part name="SENSORB" library="tcrt5000" deviceset="TCRT5000" device="" value="HPS"/>
<part name="JP1" library="pinhead" deviceset="PINHD-1X4" device="" value="IN 1-4"/>
<part name="JP2" library="pinhead" deviceset="PINHD-1X4" device="" value="OUT 1-4"/>
<part name="JP4" library="pinhead" deviceset="PINHD-1X5" device="" value="IN A-C"/>
<part name="JP3" library="pinhead" deviceset="PINHD-1X5" device="" value="OUT A-C"/>
<part name="JP5" library="pinhead" deviceset="PINHD-1X4" device="" value="OUT 5-8"/>
<part name="JP6" library="pinhead" deviceset="PINHD-1X4" device="" value="IN 5-8"/>
</parts>
<sheets>
<sheet>
<plain>
<text x="104.14" y="177.8" size="1.778" layer="91">TX ou Sensor 1
TX ou Sensor 2
TX ou Sensor 3
TX ou Sensor 4 </text>
<text x="104.14" y="96.52" size="1.778" layer="91">TX ou Sensor 5
TX ou Sensor 6
TX ou Sensor 7
TX ou Sensor 8</text>
<text x="73.66" y="134.62" size="1.778" layer="91">SENSOR A, B, C
GND
VCC
GND
TX A, B, C
</text>
</plain>
<instances>
<instance part="GND1" gate="1" x="147.32" y="111.76"/>
<instance part="P+3" gate="1" x="160.02" y="215.9"/>
<instance part="SENSOR1" gate="1" x="25.4" y="195.58" rot="R270"/>
<instance part="SENSOR2" gate="1" x="25.4" y="172.72" rot="R270"/>
<instance part="SENSOR3" gate="1" x="25.4" y="149.86" rot="R270"/>
<instance part="SENSOR5" gate="1" x="25.4" y="99.06" rot="R270"/>
<instance part="SENSOR4" gate="1" x="25.4" y="127" rot="R270"/>
<instance part="SENSOR6" gate="1" x="25.4" y="76.2" rot="R270"/>
<instance part="SENSOR7" gate="1" x="25.4" y="53.34" rot="R270"/>
<instance part="SENSOR8" gate="1" x="25.4" y="30.48" rot="R270"/>
<instance part="SENSORB" gate="OS" x="200.66" y="154.94"/>
<instance part="JP1" gate="A" x="99.06" y="180.34"/>
<instance part="JP2" gate="A" x="76.2" y="180.34"/>
<instance part="JP4" gate="A" x="116.84" y="142.24" rot="R180"/>
<instance part="JP3" gate="A" x="93.98" y="142.24" rot="R180"/>
<instance part="JP5" gate="A" x="76.2" y="99.06"/>
<instance part="JP6" gate="A" x="99.06" y="99.06"/>
</instances>
<busses>
</busses>
<nets>
<net name="V+" class="0">
<segment>
<pinref part="P+3" gate="1" pin="V+"/>
<wire x1="160.02" y1="213.36" x2="160.02" y2="142.24" width="0.1524" layer="91"/>
<wire x1="160.02" y1="142.24" x2="119.38" y2="142.24" width="0.1524" layer="91"/>
<pinref part="JP4" gate="A" pin="3"/>
<pinref part="JP3" gate="A" pin="3"/>
<wire x1="119.38" y1="142.24" x2="96.52" y2="142.24" width="0.1524" layer="91"/>
<junction x="119.38" y="142.24"/>
<junction x="96.52" y="142.24"/>
</segment>
</net>
<net name="GND" class="0">
<segment>
<pinref part="GND1" gate="1" pin="GND"/>
<wire x1="147.32" y1="114.3" x2="147.32" y2="144.78" width="0.1524" layer="91"/>
<pinref part="JP4" gate="A" pin="4"/>
<wire x1="147.32" y1="144.78" x2="119.38" y2="144.78" width="0.1524" layer="91"/>
<pinref part="JP3" gate="A" pin="4"/>
<wire x1="119.38" y1="144.78" x2="96.52" y2="144.78" width="0.1524" layer="91"/>
<junction x="119.38" y="144.78"/>
<junction x="96.52" y="144.78"/>
</segment>
</net>
<net name="N$5" class="0">
<segment>
<pinref part="SENSOR1" gate="1" pin="C"/>
<wire x1="30.48" y1="193.04" x2="48.26" y2="193.04" width="0.1524" layer="91"/>
<wire x1="48.26" y1="193.04" x2="48.26" y2="185.42" width="0.1524" layer="91"/>
<pinref part="JP2" gate="A" pin="1"/>
<pinref part="JP1" gate="A" pin="1"/>
<wire x1="73.66" y1="185.42" x2="96.52" y2="185.42" width="0.1524" layer="91"/>
<wire x1="48.26" y1="185.42" x2="73.66" y2="185.42" width="0.1524" layer="91"/>
<junction x="73.66" y="185.42"/>
<junction x="96.52" y="185.42"/>
</segment>
</net>
<net name="N$6" class="0">
<segment>
<pinref part="SENSOR2" gate="1" pin="C"/>
<wire x1="30.48" y1="170.18" x2="48.26" y2="170.18" width="0.1524" layer="91"/>
<wire x1="48.26" y1="170.18" x2="48.26" y2="182.88" width="0.1524" layer="91"/>
<pinref part="JP2" gate="A" pin="2"/>
<pinref part="JP1" gate="A" pin="2"/>
<wire x1="73.66" y1="182.88" x2="96.52" y2="182.88" width="0.1524" layer="91"/>
<wire x1="48.26" y1="182.88" x2="73.66" y2="182.88" width="0.1524" layer="91"/>
<junction x="73.66" y="182.88"/>
<junction x="96.52" y="182.88"/>
</segment>
</net>
<net name="N$7" class="0">
<segment>
<pinref part="SENSOR3" gate="1" pin="C"/>
<wire x1="30.48" y1="147.32" x2="50.8" y2="147.32" width="0.1524" layer="91"/>
<wire x1="50.8" y1="147.32" x2="50.8" y2="180.34" width="0.1524" layer="91"/>
<pinref part="JP2" gate="A" pin="3"/>
<pinref part="JP1" gate="A" pin="3"/>
<wire x1="73.66" y1="180.34" x2="96.52" y2="180.34" width="0.1524" layer="91"/>
<wire x1="50.8" y1="180.34" x2="73.66" y2="180.34" width="0.1524" layer="91"/>
<junction x="73.66" y="180.34"/>
<junction x="96.52" y="180.34"/>
</segment>
</net>
<net name="N$8" class="0">
<segment>
<pinref part="SENSOR5" gate="1" pin="C"/>
<wire x1="30.48" y1="96.52" x2="50.8" y2="96.52" width="0.1524" layer="91"/>
<wire x1="50.8" y1="96.52" x2="50.8" y2="104.14" width="0.1524" layer="91"/>
<wire x1="50.8" y1="104.14" x2="73.66" y2="104.14" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="1"/>
<pinref part="JP6" gate="A" pin="1"/>
<wire x1="73.66" y1="104.14" x2="96.52" y2="104.14" width="0.1524" layer="91"/>
<junction x="73.66" y="104.14"/>
<junction x="96.52" y="104.14"/>
</segment>
</net>
<net name="N$1" class="0">
<segment>
<pinref part="SENSOR4" gate="1" pin="C"/>
<wire x1="30.48" y1="124.46" x2="53.34" y2="124.46" width="0.1524" layer="91"/>
<wire x1="53.34" y1="124.46" x2="53.34" y2="177.8" width="0.1524" layer="91"/>
<pinref part="JP2" gate="A" pin="4"/>
<pinref part="JP1" gate="A" pin="4"/>
<wire x1="73.66" y1="177.8" x2="96.52" y2="177.8" width="0.1524" layer="91"/>
<wire x1="53.34" y1="177.8" x2="73.66" y2="177.8" width="0.1524" layer="91"/>
<junction x="73.66" y="177.8"/>
<junction x="96.52" y="177.8"/>
</segment>
</net>
<net name="N$2" class="0">
<segment>
<pinref part="SENSOR6" gate="1" pin="C"/>
<wire x1="30.48" y1="73.66" x2="53.34" y2="73.66" width="0.1524" layer="91"/>
<wire x1="53.34" y1="73.66" x2="53.34" y2="101.6" width="0.1524" layer="91"/>
<wire x1="53.34" y1="101.6" x2="73.66" y2="101.6" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="2"/>
<pinref part="JP6" gate="A" pin="2"/>
<wire x1="73.66" y1="101.6" x2="96.52" y2="101.6" width="0.1524" layer="91"/>
<junction x="73.66" y="101.6"/>
<junction x="96.52" y="101.6"/>
</segment>
</net>
<net name="N$3" class="0">
<segment>
<pinref part="SENSOR7" gate="1" pin="C"/>
<wire x1="30.48" y1="50.8" x2="55.88" y2="50.8" width="0.1524" layer="91"/>
<wire x1="55.88" y1="50.8" x2="55.88" y2="99.06" width="0.1524" layer="91"/>
<wire x1="55.88" y1="99.06" x2="73.66" y2="99.06" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="3"/>
<pinref part="JP6" gate="A" pin="3"/>
<wire x1="73.66" y1="99.06" x2="96.52" y2="99.06" width="0.1524" layer="91"/>
<junction x="73.66" y="99.06"/>
<junction x="96.52" y="99.06"/>
</segment>
</net>
<net name="N$4" class="0">
<segment>
<pinref part="SENSOR8" gate="1" pin="C"/>
<wire x1="30.48" y1="27.94" x2="58.42" y2="27.94" width="0.1524" layer="91"/>
<wire x1="58.42" y1="27.94" x2="58.42" y2="96.52" width="0.1524" layer="91"/>
<wire x1="58.42" y1="96.52" x2="73.66" y2="96.52" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="4"/>
<pinref part="JP6" gate="A" pin="4"/>
<wire x1="73.66" y1="96.52" x2="96.52" y2="96.52" width="0.1524" layer="91"/>
<junction x="73.66" y="96.52"/>
<junction x="96.52" y="96.52"/>
</segment>
</net>
<net name="N$16" class="0">
<segment>
<pinref part="SENSORB" gate="OS" pin="COLLECTOR"/>
<wire x1="231.14" y1="157.48" x2="208.28" y2="157.48" width="0.1524" layer="91"/>
<wire x1="231.14" y1="157.48" x2="231.14" y2="139.7" width="0.1524" layer="91"/>
<wire x1="231.14" y1="139.7" x2="119.38" y2="139.7" width="0.1524" layer="91"/>
<wire x1="231.14" y1="157.48" x2="231.14" y2="175.26" width="0.1524" layer="91"/>
<pinref part="JP4" gate="A" pin="2"/>
<pinref part="JP3" gate="A" pin="2"/>
<wire x1="119.38" y1="139.7" x2="96.52" y2="139.7" width="0.1524" layer="91"/>
<junction x="119.38" y="139.7"/>
<junction x="96.52" y="139.7"/>
<junction x="231.14" y="157.48"/>
<pinref part="SENSORB" gate="OS" pin="ANODE"/>
<wire x1="182.88" y1="157.48" x2="190.5" y2="157.48" width="0.1524" layer="91"/>
<wire x1="182.88" y1="175.26" x2="182.88" y2="157.48" width="0.1524" layer="91"/>
<wire x1="231.14" y1="175.26" x2="182.88" y2="175.26" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$10" class="0">
<segment>
<pinref part="JP4" gate="A" pin="1"/>
<wire x1="182.88" y1="137.16" x2="119.38" y2="137.16" width="0.1524" layer="91"/>
<pinref part="SENSORB" gate="OS" pin="CATHODE"/>
<wire x1="182.88" y1="149.86" x2="190.5" y2="149.86" width="0.1524" layer="91"/>
<wire x1="182.88" y1="137.16" x2="182.88" y2="149.86" width="0.1524" layer="91"/>
<pinref part="JP3" gate="A" pin="1"/>
<wire x1="119.38" y1="137.16" x2="96.52" y2="137.16" width="0.1524" layer="91"/>
<junction x="119.38" y="137.16"/>
<junction x="96.52" y="137.16"/>
</segment>
</net>
<net name="N$9" class="0">
<segment>
<pinref part="JP3" gate="A" pin="5"/>
<junction x="96.52" y="147.32"/>
<wire x1="170.18" y1="147.32" x2="119.38" y2="147.32" width="0.1524" layer="91"/>
<pinref part="JP4" gate="A" pin="5"/>
<wire x1="119.38" y1="147.32" x2="96.52" y2="147.32" width="0.1524" layer="91"/>
<junction x="119.38" y="147.32"/>
<pinref part="SENSORB" gate="OS" pin="EMITTER"/>
<wire x1="208.28" y1="149.86" x2="215.9" y2="149.86" width="0.1524" layer="91"/>
<wire x1="215.9" y1="167.64" x2="215.9" y2="149.86" width="0.1524" layer="91"/>
<wire x1="170.18" y1="147.32" x2="170.18" y2="167.64" width="0.1524" layer="91"/>
<wire x1="170.18" y1="167.64" x2="215.9" y2="167.64" width="0.1524" layer="91"/>
</segment>
</net>
<net name="N$11" class="0">
<segment>
<pinref part="SENSOR1" gate="1" pin="E"/>
<wire x1="7.62" y1="193.04" x2="20.32" y2="193.04" width="0.1524" layer="91"/>
<pinref part="SENSOR2" gate="1" pin="E"/>
<wire x1="7.62" y1="170.18" x2="20.32" y2="170.18" width="0.1524" layer="91"/>
<wire x1="7.62" y1="170.18" x2="7.62" y2="193.04" width="0.1524" layer="91"/>
<junction x="7.62" y="170.18"/>
<pinref part="SENSOR3" gate="1" pin="E"/>
<wire x1="7.62" y1="147.32" x2="20.32" y2="147.32" width="0.1524" layer="91"/>
<wire x1="7.62" y1="147.32" x2="7.62" y2="170.18" width="0.1524" layer="91"/>
<pinref part="SENSOR4" gate="1" pin="E"/>
<wire x1="7.62" y1="124.46" x2="20.32" y2="124.46" width="0.1524" layer="91"/>
<wire x1="7.62" y1="147.32" x2="7.62" y2="124.46" width="0.1524" layer="91"/>
<junction x="7.62" y="147.32"/>
<junction x="7.62" y="124.46"/>
<junction x="7.62" y="193.04"/>
</segment>
</net>
<net name="N$12" class="0">
<segment>
<pinref part="SENSOR5" gate="1" pin="E"/>
<wire x1="20.32" y1="96.52" x2="0" y2="96.52" width="0.1524" layer="91"/>
<pinref part="SENSOR6" gate="1" pin="E"/>
<wire x1="0" y1="73.66" x2="20.32" y2="73.66" width="0.1524" layer="91"/>
<pinref part="SENSOR7" gate="1" pin="E"/>
<wire x1="0" y1="50.8" x2="20.32" y2="50.8" width="0.1524" layer="91"/>
<wire x1="0" y1="50.8" x2="0" y2="71.12" width="0.1524" layer="91"/>
<junction x="0" y="50.8"/>
<pinref part="SENSOR8" gate="1" pin="E"/>
<wire x1="0" y1="71.12" x2="0" y2="73.66" width="0.1524" layer="91"/>
<wire x1="20.32" y1="27.94" x2="0" y2="27.94" width="0.1524" layer="91"/>
<wire x1="0" y1="27.94" x2="0" y2="50.8" width="0.1524" layer="91"/>
<wire x1="0" y1="96.52" x2="0" y2="73.66" width="0.1524" layer="91"/>
<junction x="0" y="73.66"/>
<junction x="0" y="27.94"/>
<junction x="0" y="96.52"/>
</segment>
</net>
</nets>
</sheet>
</sheets>
</schematic>
</drawing>
<compatibility>
<note version="6.3" minversion="6.2.2" severity="warning">
Since Version 6.2.2 text objects can contain more than one line,
which will not be processed correctly with this version.
</note>
</compatibility>
</eagle>
