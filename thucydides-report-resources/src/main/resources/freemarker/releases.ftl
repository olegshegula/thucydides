<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/html">
<head>
    <meta charset="UTF-8"/>
    <title>Releases</title>
    <link rel="shortcut icon" href="favicon.ico">
    <link rel="stylesheet" type="text/css" href="jqplot/jquery.jqplot.min.css"/>
    <style type="text/css">a:link {
        text-decoration: none;
    }

    a:visited {
        text-decoration: none;
    }

    a:hover {
        text-decoration: none;
    }

    a:active {
        text-decoration: none;
    }
    </style>


    <!--[if IE]>
    <script language="javascript" type="text/javascript" src="jit/Extras/excanvas.js"></script><![endif]-->

    <script type="text/javascript" src="scripts/jquery.js"></script>
    <script type="text/javascript" src="datatables/media/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="jqplot/jquery.jqplot.min.js"></script>
    <script type="text/javascript" src="jqplot/plugins/jqplot.pieRenderer.min.js"></script>

    <link type="text/css" href="jqueryui/css/start/jquery-ui-1.8.18.custom.css" rel="Stylesheet"/>
    <script type="text/javascript" src="jqueryui/js/jquery-ui-1.8.18.custom.min.js"></script>

    <script src="jqtree/tree.jquery.js"></script>
    <link rel="stylesheet" href="jqtree/jqtree.css">

    <link rel="stylesheet" href="font-awesome/css/font-awesome.min.css">
    <!--[if IE 7]>
    <link rel="stylesheet" href="font-awesome/css/font-awesome-ie7.min.css">
    <![endif]-->

    <link rel="stylesheet" href="css/core.css"/>

    <style type="text/css" media="screen">
        .dataTables_info {
            padding-top: 0;
        }

        .dataTables_paginate {
            padding-top: 0;
        }

        .css_right {
            float: right;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            $(".read-more-link").click(function () {
                $(this).nextAll("div.read-more-text").toggle();
                var isrc = $(this).find("img").attr('src');
                if (isrc == 'images/plus.png') {
                    $(this).find("img").attr("src", function () {
                        return "images/minus.png";
                    });
                } else {
                    $(this).find("img").attr("src", function () {
                        return "images/plus.png";
                    });
                }
            });
        });
    </script>
</head>

<body>
<div id="topheader">
    <div id="topbanner">
        <div id="logo"><a href="index.html"><img src="images/logo.jpg" border="0"/></a></div>
    </div>
</div>


<div class="middlecontent">
    <div id="contenttop">
        <div class="middlebg">
            <span class="bluetext"><a href="index.html" class="bluetext">Home</a> > Releases </span>
        </div>
        <div class="rightbg"></div>
    </div>

    <div class="clr"></div>

    <!--/* starts second table*/-->
<#include "menu.ftl">
<@main_menu selected="releases" />


    <div class="clr"></div>


    <div id="beforetable"></div>
    <div id="results-dashboard">
        <div class="middlb">
            <div class="table">
                <div id="releases">
                    <h3>Release Outline</h3>

                    <div id="release-tree"></div>
                    <script>
                        var releaseData = ${releaseData};
                        $(function () {
                            $('#release-tree').tree({
                                data: releaseData
                            });
                        });

                        $('#release-tree').bind(
                                'tree.click',
                                function (event) {
                                    window.location.href = event.node.reportName;
                                }
                        );

                    </script>

                </div>

                <div id="release-coverage">
                    <div id="tabs" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
                        <ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all">
                            <li class="ui-state-default ui-corner-top ui-tabs-selected ui-state-active requirementTitle">
                                <a href="#tabs-1">Release Coverage Summary</a></li>
                        </ul>
                        <!----->

                        <div id="tabs-1" class="capabilities-table">
                        <#--- Requirements -->
                            <div id="req_list_tests" class="table">
                                <div class="test-results">
                                    <table id="req-results-table">
                                        <thead>
                                        <tr>
                                            <th width="40" class="test-results-heading">&nbsp;</th>
                                            <th width="500" class="test-results-heading">Release</th>
                                            <th class="test-results-heading" width="50px">Auto.<br/>Tests</th>
                                            <th class="test-results-heading" width="50px">%Pass</th>
                                            <th class="test-results-heading" width="25px"><i
                                                    class="icon-check icon-large"
                                                    title="Tests passed (automated)"></i></th>
                                            <th class="test-results-heading" width="25px"><i
                                                    class="icon-ban-circle icon-large"
                                                    title="Tests skipped or pending (automated)"></th>
                                            <th class="test-results-heading" width="25px"><i
                                                    class="icon-thumbs-down icon-large"
                                                    title="Tests failed (automated)"></th>
                                            <th class="test-results-heading" width="25px"><i
                                                    class="icon-exclamation-sign icon-large"
                                                    title="Tests failed with an error (automated)"></th>
                                        <#if reportOptions.showManualTests>
                                            <th class="test-results-heading" width="50">Manual<br/>Tests</th>
                                            <th class="test-results-heading" width="50px">%Pass</th>
                                            <th class="test-results-heading" width="25px"><i
                                                    class="icon-check icon-large" title="Tests passed (manual)"></i>
                                            </th>
                                            <th class="test-results-heading" width="25px"><i
                                                    class="icon-ban-circle icon-large"
                                                    title="Tests skipped or pending (manual)"></th>
                                            <th class="test-results-heading" width="25px"><i
                                                    class="icon-thumbs-down icon-large"
                                                    title="Tests failed (manual)"></th>
                                            <th class="test-results-heading" width="25px"><i
                                                    class="icon-exclamation-sign icon-large"
                                                    title="Tests failed with an error (manual)"></th>
                                        </#if>
                                        </tr>
                                        <tbody>

                                        <#foreach release in releases>
                                            <#assign releaseOutcomes = requirements.getReleasedRequirementsFor(release)/>
                                            <#if releaseOutcomes.testOutcomes.stepCount == 0 || releaseOutcomes.testOutcomes.result == "PENDING" || requirementOutcome.testOutcomes.result == "IGNORED">
                                                <#assign status_icon = "traffic-yellow.gif">
                                                <#assign status_rank = 0>
                                            <#elseif releaseOutcomes.testOutcomes.result == "ERROR">
                                                <#assign status_icon = "traffic-orange.gif">
                                                <#assign status_rank = 1>
                                            <#elseif releaseOutcomes.testOutcomes.result == "FAILURE">
                                                <#assign status_icon = "traffic-red.gif">
                                                <#assign status_rank = 2>
                                            <#elseif releaseOutcomes.testOutcomes.result == "SUCCESS">
                                                <#assign status_icon = "traffic-green.gif">
                                                <#assign status_rank = 3>
                                            </#if>

                                        <tr class="test-${releaseOutcomes.testOutcomes.result} requirementRow">
                                            <td class="requirementRowCell">
                                                <img src="images/${status_icon}" class="summary-icon"
                                                     title="${releaseOutcomes.testOutcomes.result}"/>
                                                <span style="display:none">${status_rank}</span>
                                            </td>
                                            <td class="release-title">
                                                <#assign releaseReport = reportName.forRelease(release) >
                                                <a href="${releaseReport}">${release.name}</a>
                                            </td>
                                            <#assign totalAutomated = releaseOutcomes.testOutcomes.count("AUTOMATED").withAnyResult()/>
                                            <#assign automatedPassedPercentage = releaseOutcomes.testOutcomes.getFormattedPercentage("AUTOMATED").withResult("SUCCESS")/>
                                            <#assign automatedFailedPercentage = releaseOutcomes.testOutcomes.getFormattedPercentage("AUTOMATED").withFailureOrError()/>
                                            <#assign automatedPendingPercentage = releaseOutcomes.testOutcomes.getFormattedPercentage("AUTOMATED").withIndeterminateResult()/>
                                            <#assign automatedPassed = releaseOutcomes.testOutcomes.count("AUTOMATED").withResult("SUCCESS")/>
                                            <#assign automatedPending = releaseOutcomes.testOutcomes.count("AUTOMATED").withIndeterminateResult()/>
                                            <#assign automatedFailed = releaseOutcomes.testOutcomes.count("AUTOMATED").withResult("FAILURE")/>
                                            <#assign automatedError = releaseOutcomes.testOutcomes.count("AUTOMATED").withResult("ERROR")/>
                                            <#assign totalManual = releaseOutcomes.testOutcomes.count("MANUAL").withAnyResult()/>
                                            <#assign manualPassedPercentage = releaseOutcomes.testOutcomes.getFormattedPercentage("MANUAL").withResult("SUCCESS")/>
                                            <#assign manualFailedPercentage = releaseOutcomes.testOutcomes.getFormattedPercentage("MANUAL").withFailureOrError()/>
                                            <#assign manualPending = releaseOutcomes.testOutcomes.count("MANUAL").withIndeterminateResult()/>
                                            <#assign manualPendingPercentage =releaseOutcomes.testOutcomes.getFormattedPercentage("MANUAL").withIndeterminateResult()/>
                                            <#assign manualPassed = releaseOutcomes.testOutcomes.count("MANUAL").withResult("SUCCESS")/>
                                            <#assign manualFailed = releaseOutcomes.testOutcomes.count("MANUAL").withResult("FAILURE")/>
                                            <#assign manualError = releaseOutcomes.testOutcomes.count("MANUAL").withResult("ERROR")/>

                                            <td class="greentext highlighted-value">${totalAutomated}</td>
                                            <td class="greentext">${automatedPassedPercentage}</td>
                                            <td class="greentext">${automatedPassed}</td>
                                            <td class="bluetext">${automatedPending}</td>
                                            <td class="redtext">${automatedFailed}</td>
                                            <td class="lightorangetext">${automatedError}</td>
                                            <#if reportOptions.showManualTests>
                                                <td class="greentext highlighted-value">${totalManual}</td>
                                                <td class="greentext">${manualPassedPercentage}</td>
                                                <td class="greentext">${manualPassed}</td>
                                                <td class="bluetext">${manualPending}</td>
                                                <td class="redtext">${manualFailed}</td>
                                                <td class="lightorangetext">${manualError}</td>
                                            </#if>
                                        </tr>
                                        </#foreach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!----->


                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>
</div>
</div>
<div id="beforefooter"></div>
<div id="bottomfooter"></div>

</body>
</html>
