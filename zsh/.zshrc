export PATH="$HOME/.rbenv/bin:$PATH"
export FASTLANE_SKIP_UPDATE_CHECK=true
eval "$(rbenv init -)"
# java
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export JAVA_HOME="/Users/evvorobey/Library/Application Support/JetBrains/Toolbox/apps/AndroidStudio/ch-0/212.5712.43.2112.8512546/Android Studio.app/Contents/jre/Contents/Home"
# android
export ANDROID_HOME=/Users/$USER/Library/Android/sdk
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/tools/proguard/bin"
export PATH="$PATH:$FLUTTER_HOME"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:/usr/local/bin/watchman"
export PATH="$PATH:/Users/$USER/Library/Android/sdk/ndk-bundle:/Users/$USER/scripts"
# export PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"

alias lint=$ANDROID_HOME/tools/bin/lint
alias copyapk="find . -name \"*.apk\" -exec cp {} ~/Downloads \;"

# Custom scripts and aliases
alias invalidate-restart="rm -rf ~/.gradle/caches/build-cache-* && ./gradlew clean"

# fun adbproxy(){
# 	ip=
# 	adb shell settings put global http_proxy <address>:<port>
# }

export GO111MODULE=on

fun cleargit(){
	find . -path "*/build" -maxdepth 2 -delete
}

fun adb_ip() {
	for device in $(adb devices | grep device$ | sed 's/device//')
	do
		adb -s $device shell ifconfig | grep 'inet addr'
	done
}

fun ozon-restart(){
	adb shell am force-stop ru.ozon.app.android
	deeplink ozon://home
}

fun ip(){
	ifconfig | grep 'broadcast' | grep 'inet'
}
# alias ip="ifconfig | grep 'broadcast' | grep 'inet'"

alias logcat_ga="adb shell setprop log.tag.GAv4-SVC DEBUG;adb logcat -v time -s GAv4-SVC"
alias logcat_ga2="adb shell setprop log.tag.GAv4 DEBUG;adb logcat -s GAv4"
alias spy="scrcpy"

fun gradle_clean() {
	./gradlew clean && rm -rf ~/.gradle/*
}

fun scroll_down() {
	step=1
	scroll=$((1000-$2))
	while [ $step -le $1 ];
	do
		adb shell input swipe 500 1000 500 $scroll 
		step=$(($step+1))
		echo "$step"
	done
}

fun scroll_up(){
	step=1
	while [ $step -le $1 ];
	do
		adb shell input swipe 500 100 500 800
		step=$(($step+1))
		echo "$step"
	done
}

fun ozon-uninstall(){
	for device in $(adb devices | grep device$ | sed 's/device//')
	do
		adb -s $device shell pm uninstall ru.ozon.app.android.benchmark2.test;
		adb -s $device shell pm uninstall tracker.ozon.ru.trackersdk;
		adb -s $device shell pm uninstall ru.ozon.app.android.ozonder.sample;
		adb -s $device shell pm uninstall ru.ozon.app.benchmark.test;
		adb -s $device shell pm uninstall ru.ozon.app.android.qa.test;
		adb -s $device shell pm uninstall ru.ozon.app.android;
		adb -s $device shell pm uninstall ru.ozon.app.android.designexample;
		adb -s $device shell pm uninstall ru.ozon.app.android.qa
	done
}

fun ozon-clear(){
	for device in $(adb devices | grep device$ | sed 's/device//')
	do
		adb -s $device shell pm clear ru.ozon.app.android.benchmark2.test;
		adb -s $device shell pm clear tracker.ozon.ru.trackersdk;
		adb -s $device shell pm clear ru.ozon.app.android.ozonder.sample;
		adb -s $device shell pm clear ru.ozon.app.benchmark.test;
		adb -s $device shell pm clear ru.ozon.app.android.qa.test;
		adb -s $device shell pm clear ru.ozon.app.android;
		adb -s $device shell pm clear ru.ozon.app.android.designexample;
		adb -s $device shell pm clear ru.ozon.app.android.qa
	done
}

fun contract(){
	mkdir $1
	cd $1
	mkdir png
	touch $1.proto
	touch README.md
}

fun widget(){
	mkdir core data presentation
}

alias ozondebug="deeplink ozontech://debug"

fun adb_emulator(){
	echo "https://developer.android.com/studio/run/emulator-commandline"
	$ANDROID_HOME/emulator/emulator -avd Pixel_API_21_1 -netdelay none -netspeed full -no-boot-anim -no-window
}

fun animations_on(){
	for device in $(adb devices | grep device$ | sed 's/device//')
	do
		adb -s $device shell settings put global window_animation_scale 1
		adb -s $device shell settings put global transition_animation_scale 1
		adb -s $device shell settings put global animator_duration_scale 1
	done
}

fun animations_off(){
	for device in $(adb devices | grep device$ | sed 's/device//')
	do
		adb -s $device shell settings put global window_animation_scale 0
		adb -s $device shell settings put global transition_animation_scale 0
		adb -s $device shell settings put global animator_duration_scale 0
	done
}

fun killmonkey(){
	adb shell ps | awk '/com\.android\.commands\.monkey/ { system("adb shell kill " $2) }'
}
fun adbpush(){
	adb push $1 /sdcard/Downloads
}

adbpush(){
	adb push $1 /sdcard/Download
}

adbperf(){
	adb shell dumpsys gfxinfo $1 | grep 'percentile'
}
latestRecord="test"
record(){
	latestRecord=$1
	adb shell screenrecord /sdcard/Download/$1.mp4 --size 1280x720
}
lrec(){
	out=/Users/$USER/Desktop
	adb pull /sdcard/Download/$latestRecord.mp4 $out
	adb shell rm /sdcard/Download/$latestRecord.mp4
	ffmpeg -i $out/$latestRecord.mp4 -s 720x480 -c:v h264_videotoolbox -c:a aac $out/$latestRecord.compressed.mp4
	echo "Video is under $out"
}

screenshot() {
	for device in $(adb devices | grep device$ | sed 's/device//')
	do
			name=$1_$(($(date +%s)))
		# if [ "$name" == "" ]; then
		# 	name="1"
		# fi
		f=/Users/$USER/Desktop/$name.png
		adb -s $device exec-out screencap -p > $f
		echo "saved to" $f
	done
}

ozonclear(){
	for device in $(adb devices | grep device$ | sed 's/device//')
	do
		adb -s $device shell pm clear ru.ozon.app.android.qa
	done
}

# usage
# scrc test
scrc(){
	name=$1_$(($(date +%s)))
	f=/Users/$USER/Desktop/$name.png
	adb exec-out screencap -p > $f
	echo "saved to" $f
	sleep 2s
	sips -Z 1170 /Users/$USER/Desktop/*
}

deeplink(){
	for device in $(adb devices | grep device$ | sed 's/device//')
	do
		adb -s $device shell am start -a android.intent.action.VIEW -d "$1"
	done
}

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/$USER/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="tjkirch"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
git
colorize
brew
macos
npm
node
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.7.0/bin:$PATH"
