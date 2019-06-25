# Common Errors and Solutions 

## Failed to lock directory

This error is typically encountered after a failed package install. 

**Error**
```
ERROR: failed to lock directory ‘/home/robinl/R/library’ for modifying
Try removing ‘/home/robinl/R/library/00LOCK-readr’
```

**Solution**

Run the following:
```r
install.packages('pacman')
pacman::p_unlock()
```

If that does not work, or if you have trouble installing the `pacman` package, try the following:

Go to  `Tools -> Shell` and type:

`rm -rf /home/robinl/R/library/00LOCK-readr`

See [here](http://linuxcommand.org/man_pages/rm1.html) for more details.  Be careful with the `rm` command!

## `rsession-username ERROR session hadabend` 

Errors like the following can typically be ignored:

```
 [rsession-aidanmews] ERROR session hadabend; LOGGED FROM: rstudio::core::Error {anonymous}::rInit(const rstudio::r::session::RInitInfo&) /home/ubuntu/rstudio/src/cpp/session/SessionMain.cpp:1934
```

They seem to occur when R Studio has been unable to restore your session following a crash.  Note the items in your R environment will no longer be there following a crash, and you'll need to re-run your scripts to bring your data back into memory.

Crashes often occur when you run out of memory.  For now, you can use `pryr` to track your memory usage - see [here](https://rdrr.io/cran/pryr/man/mem_used.html).  We are working on giving users greater visibility of their memory usage.

## Status Code 502 error message

R Studio Server is single-cpu (single thread), which means it can’t ‘do two things at once’.

If you ask it to, sometimes one of the operations will timeout.  The 'Status code 502' message is basically a timeout message.

Usually this doesn't cause anything to crash.  You just need to wait for the currently-running code to finish executing and try again.

One example of when this can happen is if you attempt to save a file whilst a long-running script is running.  R Studio has to wait until the script has finished running to attempt to save the file.  However, sometimes the wait is too long, causing a timeout.  In this case, you just need to wait for the code to finish running, and then press save again.


## Unable to access data using `aws.s3` package.

Unfortuntely `aws.s3` does not support the granular file access permission model we are using on the platform.  Specifically, it is unable to automatically provide the user with the right file access credentials.  We provide `s3tools` as a solution to this problem, which manages your credentials for you.

We recommend that, where possible, users should use `s3tools`.  Where this is not possible, include a call to `s3tools::get_credentials()` prior to making the call to `aws.s3`, and this will guarantee that fresh credentials are generated before your call to `aws.s3`

## `s3tools::s3_path_to_full_df()` fails on Excel file

`s3tools::s3_path_to_full_df` attempts to read in data from various filetypes, including Excel, but this sometimes fails.

If it does, you have two options:

#### Option 1:  Use s3tools::read_using()

This allows you to specify what function you want to use to attempt to read the file. So, for example you can do: 
`s3tools::read_using(openxlsx::readWorkbook, path = "alpha-everyone/my_excel.xlsx")` to attempt to read the file `alpha-everyone/my_excel.xlsx` using `openxlsx::readWorkbook`

#### Option 2:  Save the file to your project directory and load it from there, rather than from S3
```
s3tools::get_credentials()
aws.s3::save_object("my_excel.xlsx", "alpha-everyone", "file_name_to_save_to_in_home_directory.xlsx")
```

and then read it in using e.g.

`openxlsx::readWorkbook("file_name_to_save_to_in_home_directory.xlsx")`

Note, it's best to avoid using `aws.s3` directly, see [here](https://github.com/moj-analytical-services/platform_user_guidance/blob/master/05-errors.Rmd#unable-to-access-data-using-awss3-package)

## Two-factor authentication problems {#two-factor-auth-issues}

Two-factor authentication (2FA) is critical to the security of the platform. We have opted to use smartphone-based authentication apps as hardware tokens, like the RSA device you use to log in to DOM1, are expensive and SMS codes are susceptible to interception.

Note that there are two layers of 2FA in action on the platform:

* Your GitHub account must have 2FA enabled. When you log in to GitHub, your session will stay active for a month before you need to re-enter your 2FA code. Your GitHub username identifies you to the platform, and we use this identity to control access to data and other resources once you've logged into the platform. You therefore must be logged into GitHub to use the platform.

* Your Analytical Platform account has a separate 2FA step. You will be prompted to set this up the first time you access the platform and on subsequent uses, depending on the machine you use and the network it's connected to:

    * From a corporate-networked machine (DOM1 or QUANTUM) or corporate wifi (e.g. MoJDigital) then you will not be challenged for this.

    * Otherwise (e.g. working from home on a non-corporate-networked machine) you'll be challenged to provide the 2FA code during every sign-in to access each part the platform: Control Panel, R Studio, Grafana etc.

This security step lets you log into the platform and use it.

Whilst you may be prompted to enter your platform 2FA frequently (e.g. when working from home), but you will not need to enter your GitHub 2FA because this is remembered for a month.

However, if you have not logged into the platform for more than a month, you will first have to login to GitHub (and enter your GitHub 2FA code), and you will then also be prompted to enter your platform 2FA code.

### I've lost my platform 2FA

If you've lost your platform 2FA code because e.g. you've broken or lost your phone, please contact the Analytical Platform team and we will reset it for you.

### I have entered my 2FA code, but the platform will not accept it

Smartphone based 2FA apps require the phone's clock (the time) to be up to date.  If your phone's clock is out of sync by more than 30 seconds or so, this can cause the 2FA codes to be out of sync.  

Most phones syncronise their time with the network provider, so this is not a problem.  If your time is out of sync, you need to navigate to your clock settings in your phone, and enable the option to sync the time.  See e.g. [here](https://android.stackexchange.com/questions/114644/how-to-force-a-time-date-update-in-my-phone)

## I'm having problems deploying a Shiny app

For help resolving deployment problems, see the [advanced deployment](https://moj-analytical-services.github.io/platform_user_guidance/deploying-a-shiny-app.html#advanced-deployment) section of the docs.
