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
"<td>Please Issue Payment to All Moves care of Rebekah Roque for client Bono in amount of $25,000</td>"\
"</tr>"\
"<tr><td>&nbsp;</td></tr>"\
"<tr>"\
"<td>"\
"<ul style=\"list-style:none; margin:0; padding:0;\">"\
"<li style=\"margin-bottom:5px;\"><strong>Mail to:</strong></li>"\
"<li>All Moves</li>"\
"<li>Rodeo Drive<br />Beverly Hills, California 90210<br />United States</li>"\
"</ul>"\
"</td>"\
"</tr>"\
"<tr><td>&nbsp;</td></tr>"\
"<tr>"\
"<td>Please enclose Closing Statement or HUD 1 with check. If wire transfer preferred, please email Rebekah Roque"\
"at <a href=\"#\" style=\" color:#0d4a6f; text-decoration:none; \">rebekah.roque@yopmail.com</a> to receive wire instructions.</td>"\
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


#endif
