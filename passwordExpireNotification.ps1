##################################################################################################################
# Configure the following variables....
$smtpServer = "smtp.FQDN.FQDN.com"
# $expireindays = 45
$from = "<eamil.com>"
$logging = "Enabled" # Set to Disabled to Disable Logging
$logFile = "C:\_SCORCH\PasswordExpiryNotification\passwordexpiry.csv" # ie. c:\mylog.csv
$testing = "Disabled" # Set to Disabled to Email Users
$testRecipient = "slichty@email.com"
$date = Get-Date -format MM/dd/yyyy
$ou = "OU=Users,DC=domain,DC=com"
###################################################################################################################

# Check Logging Settings
if (($logging) -eq "Enabled") {
    
    # Test Log File Path
    $logfilePath = (Test-Path $logFile)
    If (test-path "C:\_SCORCH\PasswordExpiryNotification\passwordexpiry.csv") { Remove-Item "C:\_SCORCH\PasswordExpiryNotification\passwordexpiry.csv" }
    if (($logFilePath) -eq "True") {
        # Create CSV File and Headers
        New-Item $logfile -ItemType File
        Add-Content $logfile "Date,FirstName,LastName,EmailAddress,DaystoExpire,ExpiresOn"
    }
} # End Logging Check

# Get Users From AD who are Enabled, Passwords Expire and are Not Currently Expired
Import-Module ActiveDirectory
$users = Get-ADUser -SearchBase $ou -filter * -properties samAccountName, GivenName, Surname, PasswordNeverExpires, PasswordExpired, PasswordLastSet, EmailAddress | where { $_.Enabled -eq $true -and $_.PasswordNeverExpires -eq $false -and $_.passwordexpired -eq $false }
$maxPasswordAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge

# Process Each User for Password Expiry
foreach ($user in $users) {
    $name = (Get-ADUser $user | ForEach-Object { $_.GivenName })
    $sur = (Get-ADUser $user | ForEach-Object { $_.SurName })
    $emailaddress = $user.emailaddress
    $passwordSetDate = (get-aduser $user -properties * | ForEach-Object { $_.PasswordLastSet })
    $PasswordPol = (Get-AduserResultantPasswordPolicy $user)
    # Check for Fine Grained Password
    if (($PasswordPol) -ne $null) {
        $maxPasswordAge = ($PasswordPol).MaxPasswordAge
    }
  
    $expireson = $passwordsetdate + $maxPasswordAge
    $today = (get-date)
    $daystoexpire = (New-TimeSpan -Start $today -End $Expireson).Days
        
    # Check Number of Days to Expiry
    $messageDays = $daystoexpire

    if (($messageDays) -ge "1") {
        $messageDays = "in " + "$daystoexpire" + " days"
    }
    else {
        $messageDays = "today."
    }

    # Email Subject Set Here
    $subject = "Your password will expire $messageDays"
  
    # Email Body Set Here.
    $body =
    @"
    <html xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:m="http://schemas.microsoft.com/office/2004/12/omml" xmlns="http://www.w3.org/TR/REC-html40"><head><meta http-equiv=Content-Type content="text/html; charset=us-ascii"><meta name=Generator content="Microsoft Word 14 (filtered medium)"><!--[if !mso]><style>v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style><![endif]--><style><!--
/* Font Definitions */
@font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:9.0pt;
	font-family:"Arial","sans-serif";
	color:#333333;}
h1
	{mso-style-priority:9;
	mso-style-link:"Heading 1 Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:21.0pt;
	font-family:"Times New Roman","serif";
	color:#002776;
	font-weight:normal;}
h2
	{mso-style-priority:9;
	mso-style-link:"Heading 2 Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:21.0pt;
	font-family:"Times New Roman","serif";
	color:#92D400;
	font-weight:normal;}
h3
	{mso-style-priority:9;
	mso-style-link:"Heading 3 Char";
	margin-top:.25in;
	margin-right:0in;
	margin-bottom:9.0pt;
	margin-left:0in;
	font-size:10.5pt;
	font-family:"Arial","sans-serif";
	color:#00A1DE;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
	{mso-style-priority:99;
	mso-style-link:"Balloon Text Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:8.0pt;
	font-family:"Tahoma","sans-serif";
	color:#333333;}
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
	{mso-style-priority:34;
	margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.5in;
	margin-bottom:.0001pt;
	font-size:9.0pt;
	font-family:"Arial","sans-serif";
	color:#333333;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.Heading1Char
	{mso-style-name:"Heading 1 Char";
	mso-style-priority:9;
	mso-style-link:"Heading 1";
	font-family:"Times New Roman","serif";
	color:#002776;}
span.Heading2Char
	{mso-style-name:"Heading 2 Char";
	mso-style-priority:9;
	mso-style-link:"Heading 2";
	font-family:"Times New Roman","serif";
	color:#92D400;}
span.Heading3Char
	{mso-style-name:"Heading 3 Char";
	mso-style-priority:9;
	mso-style-link:"Heading 3";
	font-family:"Arial","sans-serif";
	color:#00A1DE;
	font-weight:bold;}
p.Function, li.Function, div.Function
	{mso-style-name:"Function\,Industry\,Segment";
	mso-style-priority:99;
	margin:0in;
	margin-bottom:.0001pt;
	font-size:8.5pt;
	font-family:"Arial","sans-serif";
	color:gray;
	font-weight:bold;}
p.Bulletlevel1-end, li.Bulletlevel1-end, div.Bulletlevel1-end
	{mso-style-name:"Bullet level 1 - end";
	mso-style-priority:99;
	margin-top:0in;
	margin-right:0in;
	margin-bottom:12.0pt;
	margin-left:.65in;
	text-indent:-.25in;
	font-size:9.0pt;
	font-family:"Arial","sans-serif";
	color:#333333;}
p.Masthead, li.Masthead, div.Masthead
	{mso-style-name:Masthead;
	mso-style-priority:99;
	margin-top:0in;
	margin-right:0in;
	margin-bottom:6.0pt;
	margin-left:0in;
	font-size:9.0pt;
	font-family:"Arial","sans-serif";
	color:#333333;}
span.BalloonTextChar
	{mso-style-name:"Balloon Text Char";
	mso-style-priority:99;
	mso-style-link:"Balloon Text";
	font-family:"Tahoma","sans-serif";
	color:#333333;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:984823669;
	mso-list-type:hybrid;
	mso-list-template-ids:190598174 -266155512 67698691 67698693 67698689 67698691 67698693 67698689 67698691 67698693;}
@list l0:level1
	{mso-level-start-at:54;
	mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:74.7pt;
	text-indent:-.25in;
	font-family:Symbol;
	mso-fareast-font-family:Calibri;
	mso-bidi-font-family:"Courier New";}
@list l0:level2
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:110.7pt;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l0:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:146.7pt;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l0:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:182.7pt;
	text-indent:-.25in;
	font-family:Symbol;}
@list l0:level5
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:218.7pt;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l0:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:254.7pt;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l0:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:290.7pt;
	text-indent:-.25in;
	font-family:Symbol;}
@list l0:level8
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:326.7pt;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l0:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	margin-left:362.7pt;
	text-indent:-.25in;
	font-family:Wingdings;}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
    <p>
	<img src="domainHeader.jpeg" alt="somain" width="776" height="97" />
</p>
<div class="rTable">
	<div class="rTableBody">
		<div class="rTableRow">
			<div class="rTableCell">
				<p>
					Technology Center
				</p>
			</div>
		</div>
		<div class="rTableRow">
			<div class="rTableCell">
				<h1>
					Your password will expire $messageDays
				</h1>
				<h2>
					Don't get locked out!
				</h2>
				<h3>
					Reset your password before it expires
					<a name="Step1">
					</a>
				</h3>
				<p>
					<strong>
						Log in to the
					</strong>
					<a href="https://sspr.domain.com/adpassword">
						Self Service Portal
					</a>
					<strong>
						 and click the &ldquo;Change Password&rdquo; button to change your password.
					</strong>
				</p>
				<h3>
					<a name="Step2">
					</a>
					If you do not remember your password or your account has been locked out
				</h3>
				<p>
					<strong>
						Log in to
					</strong>
					<strong>
						<a href="https://sspr.domain.com/">
							SSPR Recovery
						</a>
					</strong>
					<strong>
						 and click "Recover Your Account"
					</strong>
				</p>
				<p>
					<strong>
						&middot;
					</strong>
					<strong>
						 This will require that you have already enrolled for reset
					</strong>
				</p>
				<h3>
					<a name="StrongPasswordGuidelines">
					</a>
					Strong Password Guidelines
				</h3>
				<p>
					<strong>
						Setting a new password requires that the following guidelines are met:
					</strong>
				</p>
				<p>
					<strong>
						&middot;
					</strong>
					<strong>
						 Passwords must be at least ten characters in length and
					</strong>
				</p>
				<p>
					<strong>
						&middot;
					</strong>
					<strong>
						 Password should contain at least three of the following four classes:
					</strong>
				</p>
				<p>
					<strong>
						o
					</strong>
					<strong>
						 English uppercase letters (A, B, C)
					</strong>
				</p>
				<p>
					<strong>
						o
					</strong>
					<strong>
						 English lowercase letters (a, b, c)
					</strong>
				</p>
				<p>
					<strong>
						o
					</strong>
					<strong>
						 Numbers (0, 1, 2, 3)
					</strong>
				</p>
				<p>
					<strong>
						o
					</strong>
					<strong>
						 Non-alphanumeric characters (#, %, !, %, @, ?, -, *)
					</strong>
				</p>
				<p>
					<strong>
						&middot;
					</strong>
					<strong>
						 You cannot reuse any of your previous twenty four passwords
					</strong>
				</p>
				<p>
					<strong>
						&middot;
					</strong>
					<strong>
						 Passwords should not contain:
					</strong>
				</p>
				<p>
					<strong>
						o
					</strong>
					<strong>
						 Your username
					</strong>
				</p>
				<p>
					<strong>
						o
					</strong>
					<strong>
						 Your first and/or last name
					</strong>
				</p>
				<p>
					<strong>
						o
					</strong>
					<strong>
						 A single word from the dictionary with a number/special character at the beginning or end
					</strong>
				</p>
				<h3>
					Additional Support
				</h3>
				<p>
					<strong>
						For additional support visit Service Now &ndash; Self Service to open and submit an tech related ticket.
						<br />
						Service Now-Self Service Link:
						<a href="http://serviceNow.domain.com/">
							Service Now - Self Service
						</a>
					</strong>
				</p>
				<p>
					<strong>
						For any questions or issues, contact the Tech Center at 2222 (inside office) or 1 800 domain (1 800 555 5555 outside office), or submit a non-urgent
						<a href="https://techcenter.domain.com/Support.aspx">
							support request
						</a>
					</strong>
					<strong>
						 on
					</strong>
					<strong>
						 Or contact the Tech Center.
						<br />
						TECH SUPPORT HOTLINE:
						<br />
						TCC &ndash; Tech Center
						<br />
						x2222 or + 1 (800) 555-5555
					</strong>
					<strong>
						E
					</strong>
				</p>
				<p>
					<strong>
						<a href="mailto:techcenter@domain.com">
							techcenter@domain.com
						</a>
					</strong>
				</p>
			</div>
		</div>
	</div>
</div>
"@

    # If Testing Is Enabled - Email Administrator
    if (($testing) -eq "Enabled") {
        $emailaddress = $testRecipient
    } # End Testing

    # If a user has no email address listed
    if (($emailaddress) -eq $null) {
        $emailaddress = $testRecipient    
    }# End No Valid Email

    # Send Email Message to Users 7, 3 and 1 days till expire
    if (($daystoexpire -eq 7) -or ($daystoexpire -eq 3) -or ($daystoexpire -eq 1)) {
        # If Logging is Enabled Log Details
        if (($logging) -eq "Enabled") {
            Add-Content $logfile "$date,$Name,$Sur,$emailaddress,$daystoExpire,$expireson" 
        }
        # Send Email Message (Uncomment the code below to enable email)
        Send-Mailmessage -smtpServer $smtpServer -from $from -to $emailaddress -subject $subject -body $body -bodyasHTML -priority High  

    } # End Send Message
    
} # End User Processing

taskkill /f /im "powershell.exe"

# End
