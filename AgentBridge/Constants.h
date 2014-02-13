//
//  Constants.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#ifndef AgentBridge_Constants_h
#define AgentBridge_Constants_h

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define FONT_OPENSANS_BOLD(s) [UIFont fontWithName:@"OpenSans-Bold" size:s+1.0f]
#define FONT_OPENSANS_ITALIC(s) [UIFont fontWithName:@"OpenSans-Italic-webfont" size:s]
#define FONT_OPENSANS_LIGHT(s) [UIFont fontWithName:@"OpenSans-Light-webfont" size:s]
#define FONT_OPENSANS_REGULAR(s) [UIFont fontWithName:@"OpenSans" size:s]
#define FONT_OPENSANS_SEMIBOLD(s) [UIFont fontWithName:@"OpenSans-Semibold-webfont" size:s]
#define CLIENT_INTENTION(choice) (choice == 1)?@"Buying":(choice == 2)?@"Selling":(choice == 3)?@"Buying and Selling":(choice == 4)?@"Leasing":@""
#define REFERRAL_STATUS_UNDERCONTRACT                                               1
#define REFERRAL_STATUS_CLOSED                                                      4
#define REFERRAL_STATUS_NOGO                                                        5
#define REFERRAL_STATUS_NEEDHELP                                                    6
#define REFERRAL_STATUS_PENDING                                                     7
#define REFERRAL_STATUS_ACCEPTED                                                    8
#define REFERRAL_STATUS_COMMISSIONRECEIVED                                          9

#define RESIDENTIAL_PURCHASE                                                        1
#define RESIDENTIAL_LEASE                                                           2
#define COMMERCIAL_PURCHASE                                                         3
#define COMMERCIAL_LEASE                                                            4

#define RESIDENTIAL_PURCHASE_SFR                                                    1
#define RESIDENTIAL_PURCHASE_CONDO                                                  2
#define RESIDENTIAL_PURCHASE_TOWNHOUSE                                              3
#define RESIDENTIAL_PURCHASE_LAND                                                   4
#define RESIDENTIAL_LEASE_SFR                                                       5
#define RESIDENTIAL_LEASE_CONDO                                                     6
#define RESIDENTIAL_LEASE_TOWNHOUSE                                                 7
#define RESIDENTIAL_LEASE_LAND                                                      8
#define COMMERCIAL_PURCHASE_MULTI_FAMILY                                            9
#define COMMERCIAL_PURCHASE_OFFICE                                                  10
#define COMMERCIAL_PURCHASE_INDUSTRIAL                                              11
#define COMMERCIAL_PURCHASE_RETAIL                                                  12
#define COMMERCIAL_PURCHASE_MOTEL                                                   13
#define COMMERCIAL_PURCHASE_ASSISTED_CARE                                           14
#define COMMERCIAL_PURCHASE_SPECIAL_PURPOSE                                         15
#define COMMERCIAL_LEASE_OFFICE                                                     16
#define COMMERCIAL_LEASE_INDUSTRIAL                                                 17
#define COMMERCIAL_LEASE_RETAIL                                                     18

#define FONT_SIZE_TITLE                                                             18.0f
#define FONT_SIZE_REGULAR                                                           16.0f
#define FONT_SIZE_SMALL                                                             14.0f
#define FONT_SIZE_FOR_PROFILE                                                       12.0f

#define MODIFYVIEW_NORMAL                                                           0
#define MODIFYVIEW_PENDINGREQUEST                                                   1
#define MODIFYVIEW_REQUESTTOVIEW                                                    2
#define MODIFYVIEW_CHECKSETTING                                                     3
#define MODIFYVIEW_REQUESTVIEWPRICE                                                 4

#define HTMLSTRING_INVOICE          @"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"\
"<html xmlns=\"http://www.w3.org/1999/xhtml\">"\
"<head>"\
"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"\
"<title>AgentBridge - Invoice</title>"\
"<style type=\"text/css\"> body { font-family: Arial; font-size: 12px;  -webkit-text-size-adjust: none;} </style>"\
"</head>"\
""\
"<body>"\
"<table width=\"800\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" style=\"color:#181818;\">"\
"<tr>"\
"<td>"\
"<table width=\"800\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"\
"<tr>"\
"<td valign=\"top\" ><img src=\"http://keydiscoveryinc.com/agent_bridge/images/ab_logo.jpg\" width=\"241\" height=\"69\" /></td>"\
"<td style=\"text-align:center\"><strong>Invoice</strong></td>"\
"</tr>"\
"</table>"\
"<table width=\"800\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"\
"<tr><td>&nbsp;</td></tr>"\
"<tr><td>&nbsp;</td></tr>"\
"<tr>"\
"<td valign=\"top\"><strong>Bill To:</strong></td>"\
"<td valign=\"top\">"\
"<ul style=\"list-style:none; \">"\
"<li>&nbsp;</li>"\
"<li>%@<br />%@<br />%@<br />%@<br />%@</li>"\
"</ul>"\
"</td>"\
"<td valign=\"top\" style=\"text-align:right\">"\
"<strong>Customer Information</strong>"\
"<ul style=\"list-style:none; \">"\
"<li>%@<br />%@<br />%@<br />%@<br />%@</li>"\
"</ul>"\
"</td>"\
"</tr>"\
"<tr><td>&nbsp;</td></tr>"\
"</table>"\
"<table width=\"800\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"\
"<tr>"\
"<td align=\"center\" valign=\"top\"><strong>Invoice Date</strong><br />%@</td>"\
"<td align=\"center\" valign=\"top\"><strong>Invoice Number</strong><br />%@</td>"\
"<td align=\"center\" valign=\"top\"><strong>Due Date</strong><br />%@</td>"\
"<td align=\"center\" valign=\"top\"><strong>Terms</strong><br /></td>"\
"</tr>"\
"</table>"\
""\
"<table width=\"800\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"\
"<tr><td>&nbsp;</td></tr>"\
"<tr><td>&nbsp;</td></tr>"\
"<tr>"\
"<td align=\"center\" valign=\"top\"><strong>Product</strong><br />Referral</td>"\
"<td align=\"center\" valign=\"top\"><strong>Contract</strong><br />#%@</td>"\
"<td align=\"center\" valign=\"top\"><strong>Start Date</strong><br />%@</td>"\
"<td align=\"center\" valign=\"top\"><strong>End Date</strong><br />%@</td>"\
"<td align=\"center\" valign=\"top\"><strong>Reference</strong><br />#%@</td>"\
"<td align=\"center\" valign=\"top\"><strong>Unit Price</strong><br />%@</td>"\
"<td align=\"center\" valign=\"top\"><strong>Qty</strong><br />1</td>"\
"<td align=\"center\" valign=\"top\"><strong>Amount</strong><br />%@</td>"\
"</tr>"\
"</table>"\
"<table width=\"800\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"\
"<tr><td>&nbsp;</td></tr>"\
"<tr><td>&nbsp;</td></tr>"\
"<tr>"\
"<td valign=\"top\" style=\"font-size:9px;\" align=\"left\">"\
"If you have any questions concerning this invoice, please call:<br />"\
"The Accounts Receivable Department at (310) 421-2812"\
"</td>"\
"<td valign=\"top\">Subtotal<br />Charged to Credit Card:<br /><br /><strong>TOTAL DUE</strong></td>"\
"<td valign=\"top\" align=\"right\">%@<br />[%@]<br /><br /><strong>0</strong></td>"\
"</tr>"\
"</table>"\
"<table width=\"800\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"\
"<tr><td>&nbsp;</td></tr>"\
"<tr>"\
"<td style=\"border-bottom:1px dashed #333; height:1px; text-align:center; font-size:9px\">Retain this portion for your records</td>"\
"</tr>"\
"<tr>"\
"<td align=\"center\" style=\"font-size:9px\">*Please detach this stub and return with your payments*</td>"\
"</tr>"\
""\
"</table>"\
""\
"<table width=\"800\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"\
""\
"<tr>"\
"<td valign=\"top\">"\
"<ul style=\"list-style:none; \">"\
"<li>%@<br />%@<br />%@<br />%@<br />%@</li>"\
"</ul>"\
"</td>"\
"<td valign=\"top\">"\
"<ul style=\"list-style:none; \">"\
"<li>&nbsp;</li>"\
"<li>&nbsp;</li>"\
"<li>&nbsp;</li>"\
"<li>Please make all checks payable to:</li>"\
"<li><strong>AgentBridge, LLC</strong></li>"\
"</ul>"\
"</td>"\
"</tr>"\
"</table>"\
"<table width=\"800\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"\
"<tr><td>&nbsp;</td></tr>"\
"<tr>"\
"<td align=\"center\" valign=\"top\"><strong>Cust #</strong><br />%@</td>"\
"<td align=\"center\" valign=\"top\"><strong>Customer Name</strong><br />%@</td>"\
"<td align=\"center\" valign=\"top\"><strong>Invoice Name</strong><br />%@</td>"\
"<td align=\"center\" valign=\"top\"><strong>Due Date</strong><br />%@</td>"\
"<td align=\"center\" valign=\"top\"><strong>Amount Due</strong><br />%@</td>"\
"<td align=\"center\" valign=\"top\"><strong>Amount Enclosed</strong><br /></td>"\
"</tr>"\
"<tr><td>&nbsp;</td></tr>"\
"</table>"\
"<table width=\"800\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"\
"<tr>"\
"<td valign=\"top\" style=\"width:400px;\">"\
"<ul style=\"list-style:none; \">"\
"<li>&nbsp;</li>"\
"<li>&nbsp;</li>"\
"<li>&nbsp;</li>"\
"<li>&nbsp;</li>"\
"<li>&nbsp;</li>"\
"</ul>"\
"</td>"\
"<td valign=\"top\">"\
"<ul style=\"list-style:none; \">"\
"<li><strong>Remit to:</strong></li>"\
"<li>AgentBridge, LLC</li>"\
"<li>Attn: Accounts Receivable</li>"\
"<li>608 Silver Spur<br />Rolling Hills Estates, CA 90274 Powered by</li>"\
""\
"</ul>"\
"</td>"\
"</tr>"\
"<tr><td>&nbsp;</td></tr>"\
"<tr><td>&nbsp;</td></tr>"\
"<tr><td>&nbsp;</td></tr>"\
"<tr><td>&nbsp;</td></tr>"\
"</table>"\
""\
"</td>"\
"</tr>"\
""\
"</table>"\
""\
"</body>"\
"</html>"


#define HTMLSTRING_PAYMENT          @"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"\
"<html xmlns=\"http://www.w3.org/1999/xhtml\">"\
"<head>"\
"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"\
"<title>AgentBridge - Payment</title>"\
"<style type=\"text/css\"> body { font-family: Arial; font-size: 12px;  -webkit-text-size-adjust: none;} </style>"\
"</head>"\
""\
"<body>"\
"<table width=\"800\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\" style=\"color:#181818;\">"\
"<tr>"\
"<td>"\
"<table width=\"800\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"\
"<tr>"\
"<td valign=\"top\" ><img src=\"http://keydiscoveryinc.com/agent_bridge/images/ab_logo.jpg\" width=\"241\" height=\"69\" /></td>"\
"<td style=\"text-align:left\" valign=\"top\">"\
"<ul style=\"list-style:none; margin:0; padding:0;\">"\
"<li><strong>INSTRUCTIONS TO PAY AT CLOSING</strong></li>"\
"<li>Agreement Date: %@</li>"\
"<li>Referral of %@</li>"\
"<li>Agent Bridge Referral ID: %@</li>"\
"</ul>"\
"</td>"\
"</tr>"\
"</table>"\
"<table width=\"800\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"\
"<tr><td>&nbsp;</td></tr>"\
"<tr><td>&nbsp;</td></tr>"\
"<tr>"\
"<td>Referencing AGREEMENT TO PAY REFERRAL FEE (\"Agreement\") by and between All Moves, (\"Referring Broker\")"\
"and %@ (\"Receiving Broker\") with regard to the referral of %@.</td>"\
"</tr>"\
"</table>"\
""\
"<table width=\"800\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"\
"<tr><td>&nbsp;</td></tr>"\
"<tr>"\
"<td valign=\"top\" width=\"50px\">&nbsp;</td>"\
"<td valign=\"top\">"\
"<ul style=\"list-style:none; margin:0; padding:0;\">"\
"<li style=\"margin-bottom:5px;\"><strong>REFERRING AGENT/BROKER</strong></li>"\
"<li>Broker:</li>"\
"<li>Broker State License Number:</li>"\
"<li>Agent:</li>"\
"<li>Agent License:</li>"\
"<li>Agent Mobile:</li>"\
"<li>Agent email:</li>"\
"<li>TAX ID Number:</li>"\
"</ul>"\
"</td>"\
"<td valign=\"top\" style=\"text-align:left\">"\
"<ul style=\"list-style:none; margin:0; padding:0;\">"\
"<li style=\"margin-bottom:5px;\">&nbsp;</li>"\
"<li>All Moves</li>"\
"<li>BL123</li>"\
"<li>Rebekah Roque</li>"\
"<li>AB123</li>"\
"<li>(310) 341-0201</li>"\
"<li><a href=\"#\" style=\" color:#0d4a6f; text-decoration:none; \">rebekah.roque@yopmail.com</a></li>"\
"</ul>"\
"</td>"\
"<td valign=\"top\" width=\"50px\">&nbsp;</td>"\
"</tr>"\
"<tr><td>&nbsp;</td></tr>"\
"<tr>"\
"<td valign=\"top\" width=\"50px\">&nbsp;</td>"\
"<td valign=\"top\">"\
"<ul style=\"list-style:none; margin:0; padding:0;\">"\
"<li style=\"margin-bottom:5px;\"><strong>RECEIVING AGENT/BROKER</strong></li>"\
"<li>Broker:</li>"\
"<li>Broker State License Number:</li>"\
"<li>Agent:</li>"\
"<li>Agent License:</li>"\
"<li>Agent Mobile:</li>"\
"<li>Agent email:</li>"\
"<li>TAX ID Number:</li>"\
""\
"</ul>"\
"</td>"\
"<td valign=\"top\" style=\"text-align:left\">"\
"<ul style=\"list-style:none; margin:0; padding:0;\">"\
"<li style=\"margin-bottom:5px;\">&nbsp;</li>"\
"<li>%@</li>"\
"<li>%@</li>"\
"<li>%@</li>"\
"<li>%@</li>"\
"<li>%@</li>"\
"<li><a href=\"#\" style=\" color:#0d4a6f; text-decoration:none; \">%@</a></li>"\
"<li>%@</li>"\
"</ul>"\
"</td>"\
"<td valign=\"top\" width=\"50px\">&nbsp;</td>"\
"</tr>"\
"<tr><td>&nbsp;</td></tr>"\
"<tr>"\
"<td valign=\"top\" width=\"50px\">&nbsp;</td>"\
"<td valign=\"top\">"\
"<ul style=\"list-style:none; margin:0; padding:0;\">"\
"<li style=\"margin-bottom:5px;\"><strong>PRINCIPAL</strong></li>"\
"<li>Name:</li>"\
"<li>Mobile:</li>"\
"<li>Email:</li>"\
"<li>Address:</li>"\
"<li>Principal is:</li>"\
"<li>Agreed Referral Fee:</li>"\
"</ul>"\
"</td>"\
"<td valign=\"top\" style=\"text-align:left\">"\
"<ul style=\"list-style:none; margin:0; padding:0;\">"\
"<li style=\"margin-bottom:5px;\">&nbsp;</li>"\
"<li>%@</li>"\
"<li>%@</li>"\
"<li><a href=\"#\" style=\" color:#0d4a6f; text-decoration:none; \">%@</a></li>"\
"<li>%@</li>"\
"<li>%@</li>"\
"<li>%@</li>"\
"</ul>"\
"</td>"\
"<td valign=\"top\" width=\"50px\">&nbsp;</td>"\
"</tr>"\
"<tr><td>&nbsp;</td></tr>"\
"<tr>"\
"<td valign=\"top\" width=\"50px\">&nbsp;</td>"\
"<td valign=\"top\">"\
"<ul style=\"list-style:none; margin:0; padding:0;\">"\
"<li style=\"margin-bottom:5px;\"><strong>TRANSACTION DETAILS</strong></li>"\
"<li>Client Transaction Completed</li>"\
"<li>Gross Commission of Sale</li>"\
"<li>Referral Fee Percentage</li>"\
"<li>Referral Fee</li>"\
"</ul>"\
"</td>"\
"<td valign=\"top\" style=\"text-align:left\">"\
"<ul style=\"list-style:none; margin:0; padding:0;\">"\
"<li style=\"margin-bottom:5px;\">&nbsp;</li>"\
"<li>%@</li>"\
"<li>%@</li>"\
"<li>%@</li>"\
"<li><strong>%@</strong></li>"\
"</ul>"\
"</td>"\
"<td valign=\"top\" width=\"50px\">&nbsp;</td>"\
"</tr>"\
"</table>"\
"<table width=\"800\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">"\
""\
"<tr><td>&nbsp;</td></tr>"\
"<tr>"\
"<td>Please Issue Payment to %@ care of %@ for client %@ in amount of %@</td>"\
"</tr>"\
"<tr><td>&nbsp;</td></tr>"\
"<tr>"\
"<td>"\
"<ul style=\"list-style:none; margin:0; padding:0;\">"\
"<li style=\"margin-bottom:5px;\"><strong>Mail to:</strong></li>"\
"<li>%@</li>"\
"<li>%@<br />%@, %@ %@<br />%@</li>"\
"</ul>"\
"</td>"\
"</tr>"\
"<tr><td>&nbsp;</td></tr>"\
"<tr>"\
"<td>Please enclose Closing Statement or HUD 1 with check. If wire transfer preferred, please email %@"\
"at <a href=\"#\" style=\" color:#0d4a6f; text-decoration:none; \">%@</a> to receive wire instructions.</td>"\
"</tr>"\
""\
"</table>"\
""\
"</td>"\
"</tr>"\
"<tr><td>&nbsp;</td></tr>"\
"<tr><td>&nbsp;</td></tr>"\
"<tr><td>&nbsp;</td></tr>"\
""\
"</table>"\
""\
"</body>"\
"</html>"


#define HTMLSTRING_TERMS @"<html><head></head><body>"\
"<strong>AgentBridge Terms and Conditions</strong></br>"\
"<p>(last updated October 19, 2013)</p></br>"\
"<p>PLEASE READ THESE TERMS AND CONDITIONS OF USE CAREFULLY BEFORE USING THIS WEB SITE. BY ACCESSING AND USING THIS WEB SITE AT <a href="">WWW.AGENTBRIDGE.COM</a> AND <a href="">WWW.M.AGENTBRIDGE.COM</a> (THE \"WEB SITE\"), YOU EXPLICITLY AGREE TO COMPLY WITH AND BE BOUND BY THE FOLLOWING TERMS AND CONDITIONS (THE \"TERMS OF USE\").</p></br>"\
"<p>AgentBridge reserves the right to change or modify these Terms of Use or any policy or guideline of the Web Site, at any time and in its sole discretion. Any changes or modification will be effective immediately upon posting of the revisions to the Web Site, and you waive any right you may have to receive specific notice of such changes or modifications. Your continued use of the Web Site following the posting of changes or modifications will confirm your acceptance of such changes or modifications. Please review these terms and conditions periodically and check the version date for changes.</p></br>"\
"<strong>General</strong></br>"\
"<p>AgentBridge, Inc. and its subsidiaries and affiliates, as applicable, (collectively, \"AgentBridge\") provide you with access to this Web Site and the services offered by AgentBridge available on it, or other Web sites as indicated below (collectively, the \"Services\"). Access to and use of the Services is governed by these Terms of Use.</p></br>"\
"<strong>Privacy</strong></br>"\
"<p>Information about you is subject to the AgentBridge Privacy Policy. For more information, please review our full Privacy Policy.</p></br>"\
"<strong>Services</strong></br>"\
"<p>The Services include the AgentBridge Web Site, AgentBridge private, off-market and potential listings (POPs™), reference by AgentBridge to another party or property for purposes of a potential transaction which may result in an agreement between two real estate professionals to pay an agreed upon commission upon the sale of a property for or to a referred client (\"Referrals\"), hosting digital records reflecting a client's ideal property description (\"Buyers\"), and other content, products and/or services available on the Web Site. The Services may also be located on third party Web sites and/or applications either as a link from an add-on service to, or otherwise in connection with, Web sites and/or applications that such third parties control. Nothing contained in any of the Services is an offer or promise to sell a specific product for a specific price or that any advertiser will sell any product or service for any purpose or price or on any specific terms.</p></br>"\
"<strong>Membership Eligibility</strong></br>"\
"<p>The AgentBridge Services are only available to select real estate professionals that meet and retain certain qualifications as disclosed to you through the AgentBridge registration process. Real estate professionals must also abide by the terms of the AgentBridge Membership Guidelines. AgentBridge does not discriminate on the basis of race, religion, national origin, color, sex, age, veteran status or disability. Furthermore, the AgentBridge Services are only available if you accept these Terms of Use, the Privacy Policy, the Content Agreement and the Membership Guidelines.</p></br>"\
"<strong>Third Party Advertising and Business Dealings</strong></br>"\
"<p>AgentBridge may run advertisements and promotions from third parties on the Web Site or may otherwise provide information about or links to third-party products or services on the Web Site. Your business dealings with or participation in the promotions of such third parties, and any terms, conditions, warranties, or representations associated with such dealings or promotions, are solely between you and such third party. AgentBridge is not responsible for and does not guarantee the price, terms, performance, quality, accuracy, availability or legality of any products, services, promotions or information offered by any advertiser. We are not responsible or liable for any loss or damage of any sort incurred as the result of such dealings or promotions or as a result of such third party information or advertisements on the Web Site. If you have a dispute with one or more advertisers or other third parties, you release and hold AgentBridge harmless from any claims, demands and damages (actual and consequential) of every kind and nature, known and unknown, suspected and unsuspected, disclosed and undisclosed, arising out of or in any way connected with such disputes.</p></br>"\
"<strong>User Submitted Content</strong></br>"\
"<p>You are solely responsible for any listings, listing content, messages, reviews, text, maps, documents, photos, videos, graphics, code, or other content or materials (the \"User Content\") that you post, submit, publish, display or link to on the Web Site or send to other AgentBridge users. You agree not to post, submit or link to any User Content or material that infringes, misappropriates or violates the rights of any third party, including without limitation the copyright, trademark, trade secret, patent, publicity, privacy or other intellectual property rights of any third party, or that is in violation of any Federal, State or local law, rule or regulation, including Fair Housing Laws. You also agree not to post, submit or link to any User Content that is defamatory, obscene, pornographic, indecent, harassing, threatening, abusive, inflammatory, or fraudulent or that is purposely false or misleading. Without limiting the foregoing, you will at all times adhere to the AgentBridge Membership Guidelines, which are incorporated into these Terms of Use. You agree that by posting content on the Web Site, you are granting AgentBridge a royalty-free, perpetual, irrevocable and fully sublicensable license to publish, reproduce, distribute, display, adapt, modify, store, deliver, create derivative works of and otherwise use User Content in any manner on or in connection with the Web Site or in the course of offering the Services. This license is perpetual and shall survive the expiration or termination of this Agreement, regardless of whether the User Content remains on the Web Site or has been removed or deleted. You understand and agree that any User Content that you post or submit to AgentBridge may be redistributed through the internet and other media channels, and may be viewed by the general public, subject to the terms of the AgentBridge Privacy Policy. For specific advice on legal, financial or real estate matters, you should always seek the advice of a professional who is licensed and knowledgeable in that area, such as an attorney, accountant or real estate agent or broker. AgentBridge is not your agent or broker and is not representing either party in any real estate matters. You understand that AgentBridge does not approve or control the User Content posted by you or others, and instead simply provides a service by allowing users to access information that has been made available by others. As a provider of interactive services, AgentBridge is not liable for any statements, representations, or User Content provided by you or its users on the Web Site or in connection with the Services. AgentBridge assumes no responsibility for monitoring the Web Site or the Services for appropriate User Content or conduct and has no obligation to screen, edit, or remove any of the User Content. However, AgentBridge reserves the right, in its sole discretion and without notice, to monitor, screen, edit, or remove any User Content at any time and for any reason or for no reason. AgentBridge nonetheless assumes no responsibility for such User Content or for the conduct of the User submitting any such Content. You understand that AgentBridge does not endorse or warrant any particular content or information available via the Web Site or guarantee the accuracy, integrity or quality of such content or information. Additionally, we cannot guarantee the authenticity of any data which users may provide about themselves. You acknowledge that by using the Service, you may be exposed to User Content that is offensive, indecent or objectionable. Under no circumstances will AgentBridge be liable in any way for any User Content, including, but not limited to, any errors or omissions in any User Content, or any loss or damage of any kind incurred as a result of the use of any User Content posted, emailed, transmitted or otherwise made available via the Web Site or the Service. You use the Web Site and the Services at your own risk and you hold AgentBridge harmless.</p></br>"\
"<strong>Terms involving AgentBridge Referrals and AgentBridge POPs™</strong></br>"\
"<strong>Requirements for using AgentBridge:</strong></br>"\
"<p>-You will provide accurate, complete, current, and truthful information when you add or edit facts about your POPs™, Buyers, Referrals, or otherwise provide content on the Web Site.</p>"\
"<p>-You will not publish any material that violates any laws or regulations. This includes, but is not limited to, stating discriminatory preferences in advertisements for housing in accordance with the provisions of the Fair Housing Act.</p>"\
"<p>-You agree not to make any statements that are otherwise discriminatory, inflammatory, obscene, inappropriate, threatening, libelous or otherwise objectionable.</p>"\
"<p>-You agree not to post copyrighted material without permission from the owner of the copyright. This includes, for example, photographs or other content you upload to the Web Site.</p>"\
"<p>-You will not disclose confidential or sensitive information. This includes but is not limited to information about neighbors or other information that would potentially be viewed as an invasion of privacy.</p>"\
"<strong>Materials You Provide:</strong></br>"\
"<p>-For information or materials you provide to us or in connection with the Services, you grant to AgentBridge the license set forth above under User Submitted Content.</p>"\
"<p>-We will not pay you or otherwise compensate you for content you provide to us.</p>"\
"<p>-You are responsible for all actions taken or content added through your account.</p>"\
"<strong>Communicating With You:</strong></br>"\
"<p>-By joining AgentBridge, you agree that we can send you emails and texts about your POPs™, Referrals and Buyers. You can unsubscribe from these emails and texts through the instructions in any of these emails or by updating your preferences in the account settings section of the Web Site.</p>"\
"<strong>Your Responsibilities:</strong></br>"\
"<p>-By posting POPs™, Buyers and Referrals into the system you are abiding by the Intent of the Web Site. The Intent is to match Buyer's needs with POPs™ that are not subject to a formal listing agreement requiring submission to a MLS or other listing services.</p>"\
"<p>-By posting POPs™ you are stating that you are authorized to represent owner of property for purpose of identifying potential Buyers prior to formal listing of property.</p>"\
"<p>-You are responsible for removing POPs™ from the AgentBridge Web Site once a formal listing agreement has been executed with the owner of the property. If a signed waiver has been granted by owner to privately list a property, property may remain on the AgentBridge Web Site for the period of the waiver.</p>"\
"<p>-You are responsible, for removing POPs™ from the AgentBridge Web Site, if at any time the property is listed on a MLS. AgentBridge will delete any POPs™ found to be currently listed on any MLS.</p>"\
"<p>-No written agreement in compensation nor commitment to buyer or sell is either presented or implied. All terms of a transaction shall be determined between representing parties and AgentBridge is not a party in such transaction.</p>"\
"<p>-You are responsible for confirming the accuracy of any details that you provide.</p>"\
"</br>"\
"<p>We provide a Web Site for licensed or authorized real estate professionals to post properties they deem to be their listings, and client wishes they deem to be a \"buyer need\" (Posts). We do not take responsibility for the accuracy of a real estate agent's claims or their Posts. We do not verify the validity of their claims. We do not collect a commission for Posts and we do not regulate commission agreements an agent or professional may offer for procuring a sale from a Post on our Web Site. Furthermore, we do not verify or regulate whether our users are abiding by their local Department of Real Estate rules and regulations regarding listings and timeframes for submitting a listing to their local MLS, or agreements to exclude a listing from their local MLS; however our users are expected to abide by their local regulations. Our service is akin to placing a note on a bulletin board and the scope of our responsibility does not extend beyond maintenance and security of our Web Site. We take absolutely no responsibility for the accuracy of statements made in a Post and we cannot guarantee the accuracy of any such claims.</p>"\
"<strong>How We Use Information:</strong></br>"\
"<p>-You acknowledge that information that you provide about your POPs™, Buyers and Referrals will be posted in public areas of the Web Site and will be available to any AgentBridge member who visits the Web Site.</p>"\
"<p>-You acknowledge that we may display information about yourself, POPs™, Buyers and Referrals from other sources and that there may be discrepancies between the information provided by you and the information provided by these other sources; you release us from liability for any inconsistent information. However, you agree to notify us of any inconsistencies or discrepancies so we may assess the need to modify our Web Site. Our use of information is further described in the AgentBridge Privacy Policy.</p>"\
"<strong>Modification of AgentBridge Services</strong></br>"\
"<p>AgentBridge reserves the right to modify or discontinue the Service or a portion or attribute thereof, or the offering of any information, good, content, product or service with or without notice. AgentBridge shall not be liable to you or any third party should AgentBridge exercise its right to modify or discontinue the Service or part of it.</p></br>"\
"<strong>Copyright And License</strong>"\
"<p>All copyrighted and copyrightable materials on this Web Site, including, without limitation, the design, text, search results, graphics, images, pictures, sound files and other files, and the selection and arrangement and compilation of information, software, programs, processes and any other functionality contained in or on the Web Site, and all of the content on the Web Site other than your content (\"Materials\") thereof are proprietary property of AgentBridge or its licensors, or users and are protected by U.S. and international copyright laws. You agree not to contest AgentBridge's ownership claims, or disassemble, reverse engineer, license, sub-license, or re-license any of the AgentBridge Materials at any time, or assist or enable any other person to do so, without AgentBridge's express written consent, which AgentBridge may withhold in its sole discretion.</p>"\
"<p>You are granted a limited, non-sublicensable right to access this Web Site, use the Services and print the Materials for your personal, non-commercial, and informational use only. We reserve the right, without notice and in our sole discretion, to terminate your license to use the Web Site, and to block or prevent future access to and use of the Web Site. The foregoing license grant does NOT include the right for you to:</p>"\
"<p>a. publish, publicly perform or display, or distribute to any third party any Materials, including reproduction on any computer network or broadcast or publications media;</p>"\
"<p>b. market, sell or make commercial use of the Web Site or any Materials;</p>"\
"<p>c. systematically collect and use of any data or content including the use of any data spiders, robots, or similar data gathering, mining or extraction methods;</p>"\
"<p>d. make derivative uses of the Web Site or the Materials; or</p>"\
"<p>e. use, frame or utilize framing techniques to enclose any portion of this Web Site (including the images found at this Web Site or any text or the layout/design of any page or form contained on a page).</p></br>"\
"<p>Except for the limited license granted to you, you are not conveyed any other right or license by implication, estoppels, or otherwise in or under any patent, trademark, copyright, or proprietary right of AgentBridge or any third party. Any unauthorized use of this Web Site will terminate the permission or license granted by these Web Site Terms of Use and may violate applicable law including copyright laws, trademark laws (including trade dress), and communications regulations and statutes.</p></br>"\
"<strong>Trademarks and Service Marks</strong></br>"\
"<p>\"AgentBridge\" and our logos are either trademarks, service marks or registered trademarks of AgentBridge, Inc. or its suppliers and licensors, and may not be copied, imitated or used, in whole or in part, without our prior written permission or that of our suppliers or licensors. You may not use any meta tags or any other \"hidden text\" utilizing \"AgentBridge\" or any other name, trademark, or product name of AgentBridge without our permission. In addition, all page headers, custom graphics, button icons, and scripts are service marks, trademarks, and/or trade dress of AgentBridge, and may not be copied, imitated, or used, in whole or in part, without our prior written permission. All other trademarks, registered trademarks, product names and AgentBridge's names or logos mentioned herein are the property of their respective owners. Reference to any products, services, processes, or other information, by trade name, trademark, manufacturer, supplier, or otherwise does not constitute or imply endorsement, sponsorship or recommendation thereof by us.</p></br>"\
"<strong>Links to Other Sites</strong></br>"\
"<p>The Services contain links to third-party Web sites. These third-party sites are not under the control of AgentBridge. We are providing these links to you only as a convenience, and the inclusion of any link does not imply affiliation, endorsement, or adoption by us of the site or any information contained therein. AgentBridge is not responsible or liable for the contents of any linked site. You should make whatever investigation you feel necessary or appropriate before proceeding with any transaction with any of these third parties. When leaving this Web Site, you should be aware that our terms and policies no longer govern, and, therefore, you should review the applicable terms and policies, including privacy and data gathering practices, of that site.</p></br>"\
"<p>Information Provided by Real Estate Professionals</p>"\
"<p>You agree that you will not claim or submit POPs™, Referrals or Buyers that do not belong to you. When you submit or claim a listing, you hereby agree to abide by these Terms of Use</p></br>"\
"<strong>Digital Millennium Copyright Act Compliance</strong></br>"\
"<p>In accordance with the provisions of the Digital Millennium Copyright Act (DMCA) applicable to Internet service providers (17 U.S.C. 512)), AgentBridge has adopted a policy of terminating, in appropriate circumstances and at our sole discretion, subscribers or account holders who are deemed to be infringers. If you believe that your work has been copied and has been posted to this Web Site in a way that constitutes copyright infringement, please provide AgentBridge's copyright agent the following written information:</p>"\
"<p>-An electronic or physical signature of the person authorized to act on behalf of the owner of the copyright interest;</p>"\
"<p>-A description of the copyrighted work that you claim has been infringed upon;</p>"\
"<p>-A description of where the material that you claim is infringing is located on the Web Site;</p>"\
"<p>-Your address, telephone number, and e-mail address;</p>"\
"<p>-A statement by you that you have a good-faith belief that the disputed use is not authorized by the copyright owner, its agent, or the law;</p>"\
"<p>-A statement by you, made under penalty of perjury, that the above information in your notice is accurate and that you are the copyright owner or authorized to act on the copyright owner's behalf.</p></br>"\
"<p>Before sending a notice to AgentBridge, you should confirm that you are the copyright owner or have rights to the copyright which the DMCA requires. Contact information for AgentBridge's Copyright Agent for notice of claims of copyright infringement is provided below.</p>"\
"<p>DMCA Agent: AgentBridge Legal Department</p>"\
"<p>Address:</p>"\
"<p>608 Silver Spur</p>"\
"<p>Rolling Hills Estates, CA 90274</p>"\
"<p>USA</p>"\
"<p>Phone No.: (310) 870-1231 x701</p>"\
"<p>Facsimile No.:(310) 878-0584</p>"\
"<p>Email address: agentservice@AgentBridge.com</p></br>"\
"<strong>Enforcement</strong></br>"\
"<p>Enforcement of these Terms of Use is solely in our discretion, and failure to enforce the Terms of Use in some instances does not constitute a waiver of our right to enforce them in other instances. In addition, these Terms of Use do not create any private right of action on the part of any third party or any reasonable expectation that the Web Site will not contain any content that is prohibited by these Terms of Use.</p></br>"\
"<strong>Indemnification</strong></br>"\
"<p>AgentBridge provides the Services to you independent of your business transactions with other Members of the AgentBridge Web Site and/or third parties and AgentBridge is not a party to any transaction you enter into with other AgentBridge Members or third parties.</p>"\
"<p>You agree to defend, indemnify, and hold harmless AgentBridge from and against any claim, suit, or action arising out of or related to: 1) the use of the Web Site and Services, 2) User Content you post, store or otherwise transmit on or through the Web Site, 3) your violation of the Privacy Policy, 4) your violation of these Terms of Use, 5) your violation of the Membership Agreement, 6) your violation of the rights of any third party, 7) your violation of any law, or 8) your business transactions with third parties or other Members of the AgentBridge Services, including any liability or expense arising from claims, losses, damages, suits, judgments, litigation costs and attorneys' fees.</p></br>"\
"<strong>No Warranties</strong></br>"\
"<p>THIS WEB SITE, THE MATERIALS, AND THE SERVICES ARE PROVIDED ON AN \"AS IS\" BASIS WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED. YOU EXPRESSLY AGREE THAT USE OF THIS WEB SITE, INCLUDING ALL CONTENT OR DATA DISTRIBUTED BY, DOWNLOADED OR ACCESSED FROM OR THROUGH THIS WEB SITE, IS AT YOUR SOLE RISK. WE DISCLAIM ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND NON-INFRINGEMENT AS TO THE INFORMATION, MATERIALS, AND CONTENT ON THE WEB SITE. WE DO NOT REPRESENT OR WARRANT THAT MATERIALS IN THIS WEB SITE ARE ACCURATE, COMPLETE, RELIABLE, CURRENT, OR ERROR-FREE. WE ARE NOT RESPONSIBLE FOR TYPOGRAPHICAL ERRORS OR OMISSIONS RELATING TO PRICING, TEXT OR PHOTOGRAPHY.</p></br>"\
"<strong>Limitation of Liability</strong></br>"\
"<p>IN NO EVENT SHALL AGENTBRIDGE, ITS OFFICERS, DIRECTORS, AGENTS, AFFILIATES, EMPLOYEES, ADVERTISERS, OR DATA PROVIDERS BE LIABLE FOR ANY INDIRECT, SPECIAL, INCIDENTAL, CONSEQUENTIAL OR PUNITIVE DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE, LOSS OF PROFITS, OR LOSS OF DATA) WHETHER IN AN ACTION IN CONTRACT, TORT (INCLUDING BUT NOT LIMITED TO NEGLIGENCE), EQUITY OR OTHERWISE, ARISING OUT OF OR IN ANY WAY CONNECTED WITH THE USE OF THIS WEB SITE, THE MATERIALS OR SERVICES. SOME JURISDICTIONS DO NOT ALLOW THE EXCLUSION OR LIMITATION OF LIABILITY SO A PORTION OF OR ALL OF THE ABOVE LIMITATIONS MAY NOT APPLY TO YOU. TO THE EXTENT PERMITTED BY LAW, THE TOTAL LIABILITY OF AGENTBRIDGE, AND ITS SUPPLIERS AND DISTRIBUTORS, FOR ANY CLAIM UNDER THESE TERMS, INCLUDING FOR ANY IMPLIED WARRANTIES, IS LIMITED TO THE AMOUNT YOU PAID US TO USE THE SERVICES (OR, IF WE CHOOSE, TO SUPPLYING YOU THE SERVICES AGAIN). IN ALL CASES, AGENTBRIDGE, AND ITS SUPPLIERS AND DISTRIBUTORS, WILL NOT BE LIABLE FOR ANY LOSS OR DAMAGE THAT IS NOT REASONABLY FORESEEABLE.</p></br>"\
"<strong>Disclaimer of Responsibility for Third Party Content</strong></br>"\
"<p>AgentBridge may provide third party content on the Web Site and may provide links to Web pages and content of third parties (collectively the \"Third Party Content\") as a service to those interested in this information. AgentBridge does not monitor or have any control over any Third Party Content or third party Web sites. Any opinions, advice, statements, services, offers, or other information or content expressed or made available by third parties, including information providers and users, are those of the respective author(s) or distributor(s) and not AgentBridge. In many instances, the content available through this Web Site represents the opinions and judgments of the respective information providers or users. AgentBridge does not endorse or adopt any Third Party Content, and is not responsible for and does not guarantee the accuracy, completeness or reliability of any Third Party Content or any opinion, advice or statement made on the site by any third party. Users use such Third Party Content contained therein at their own risk.</p></br>"\
"<strong>Choice of Law, Waiver, and Claims</strong></br>"\
"<p>These Terms of Use shall be governed by the laws of the State of California without regard to its conflict of law provisions. AgentBridge's failure to exercise or enforce any right or provision of the Terms of Use will not be deemed to be a waiver of such right or provision. If any provision of these Terms of Use is found by a court of competent jurisdiction to be invalid, the parties nevertheless agree that the court should endeavor to give effect to the parties' intentions as reflected in the provision, and the other provisions of these Terms of Use remain in full force and effect. You agree that regardless of any statute or law to the contrary, any claim or cause of action arising out of or related to use of the Services must be filed within one (1) year after such claim or cause of action arose or be forever barred.</p></br>"\
"<strong>Arbitration</strong></br>"\
"<p>Any controversy or claim arising out of or relating to these Terms of Use or the Services will be settled by binding arbitration in accordance with the commercial arbitration rules of the American Arbitration Association (\"AAA\"). The arbitration must be conducted in Los Angeles, California, and judgment on the arbitration award may be entered into any court having jurisdiction thereof. Either AgentBridge or you may seek any interim or preliminary relief from a court of competent jurisdiction in Los Angeles, California, as necessary to protect the rights or property of you or AgentBridge.</p></br>"\
"<strong>Relationship of the Parties</strong></br>"\
"<p>Nothing in this Agreement is intended or shall be deemed to constitute a partnership, agency, employer-employee, or joint venture relationship between the Parties.</p></br>"\
"<p>Copyright © 2013 AgentBridge, Inc. ALL RIGHTS RESERVED.</p>"\
"</body></html>"

#endif
