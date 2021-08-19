EmailMax 2K Version
================================================
Updated June 18, 2002

Contents
1     Whats New
2     Know bugs
  2.3 Details on known issues
3     Setup
4     Sending Emails
5     Receiving Emails
  5.1 Some Email accounts will not work
6     Encryption via PGP
7     Using Spaminator
8     Bug Reporting

1 Whats New in this release?
    * See the help file emailmax2k.hlp, in the installation directory,
      for complete information on new features and improvements
      in Emailmax

2 Known Issues
  2.1 See 5.1 Some Email accounts will not work
  2.2 If you get *authentication failed* error message, this may be 
      a bug.  Some times passwords do not get saved correctly.  To
      correct the problem, reenter the password.  This usually
      fixes the problem.
  2.3 See http://www.microobjects.com/emailmax for the latest
      information on known issues and work arounds.

3 Setup (after installation):
    If you did not use the account setup wizard 
    during the install,  you will need to setup at 
    least one email account to send email through 
    and at least one email account to receive 
    email from.

    Enter the setup through the menu FILE.  Select 
    SETUP. You will need to know if the account works 
    through a POP or an SMTP server.  With a POP 
    account, the account password will be required.

    (In most cases, mail is sent out via an SMTP 
     server and received from a POP server).

4 To Send Email
    Click on FILE | NEW EMAIL from the main 
    application window.

5 To Receive Email
    Select Received from VIEW menu and click "check mail".  
    Receive currently only retrives unread mail and 
    leaves it on the server. The final release will 
    leave this option open for you to define.

5.1 Some Email accounts will not work
    This information below applies ONLY TO RECEIVING
    email within Emailmax.

    For example, if you have an email account with Yahoo! 
    Pager but not with Yahoo! Online account, emailmax 
    will not work.  AOL is not supported either.  

    Essentially, Emailmax only works with accounts where
    the POP3 server is accessible for retrieval from
    a connection point (such as dial up networking).

    The following are known to cause problems:
    1) America Online
    2) Compuserve
    3) Has not been tested with hotmail

    Testing with Yahoo! Mail seems to work following the 
    instructions provided by Yahoo for smtp and pop 
    server names.   However, Yahoo! Mail seems to 
    rather unreliable, even with MS Outlook.


6 PGP Encryption/Decryption
    You must have PGP correctly installed for EmailMax
    to work with PGP.  Emailmax requires a commandline 
    version of PGP.  Both PGP 2.6.2 and PGPFreeware 6.5.8
    (with command line option installed) work with
    Emailmax.

    PGP (pretty good privacy) IS NOT INSTALLED with 
    Emailmax.  This is a separate program and its 
    distribution is regulated by the United States 
    Government.

    If you live outside of the United States and wish
    to use PGP, you can either a) download the restricted 
    export version of PGP; b) or find the source for 
    PGP printed in a book; c) or whatever you can come up
    with.

    A good place to look is at http://jya.com/crypto-free.htm

7 Using Spaminator
    Please refer to the included help file for information
    on how to use the Spaminator.


8 Bug Reporting
    Send all bug reports to mattr@microobjects.com.  
    Please visit our site for information on new features 
    and new versions.

    www.microobjects.com.   



