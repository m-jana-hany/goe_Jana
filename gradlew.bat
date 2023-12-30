@echo off
setlocal

set DIRNAME=%~dp0
set APP_HOME=%DIRNAME%

set DEFAULT_JVM_OPTS=
set GRADLE_OPTS=

if not "%JAVA_HOME%" == "" goto findJavaFromJavaHome

set JAVA_EXECUTABLE=java.exe
goto findJavaFromJavaExecutable

:findJavaFromJavaHome
set JAVA_EXECUTABLE=%JAVA_HOME%\bin\java.exe

:findJavaFromJavaExecutable
if not exist "%JAVA_EXECUTABLE%" goto noJava

"%JAVA_EXECUTABLE%" %DEFAULT_JVM_OPTS% %GRADLE_OPTS% "-Dorg.gradle.appname=%APP_BASE_NAME%" -classpath "%APP_HOME%\gradle\wrapper\gradle-wrapper.jar" org.gradle.wrapper.GradleWrapperMain %*

goto end

:noJava
echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

:end
