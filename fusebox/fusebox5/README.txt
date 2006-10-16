Fusebox 5 Core Files

The simplest way to install Fusebox 5 is to copy this (fusebox5)
directory to your webroot.

Alternatively, you can create a mapping /fusebox5 that points to
this directory.

Then install the Fusebox 5 Skeleton application template
(see the Downloads section of fusebox.org) and test that
it works.

Fusebox 5 supports:
- ColdFusion MX 6.1 and higher
- BlueDragon 6.2.1 Server, JX and J2EE on JVM 1.4.2
  (BlueDragon.NET 6.2.1 and BlueDragon 6.2.1 J2EE on JVM 1.5
   require the July hot fix from New Atlanta that brings the
   build number to 6,2,1,311)
- BlueDragon 7.0 Beta
- Railo 1.0.0.025 and higher

Non-English Operating Systems:
- Some non-English operating systems only provide the "date last
  modified" for files to the closest minute. This can cause the
  core files to take up to a minute to detect that a circuit XML
  file (or the fusebox XML file) has been modified and therefore
  needs to be reloaded. This is a known issue for German-locale
  Windows XP, for example. A fix for this is under consideration
  for Fusebox 5.1.

See the official What's New In Fusebox 5 documentation:

	http://fusebox.org/index.cfm?fuseaction=documentation.WhatsNewInFusebox5
