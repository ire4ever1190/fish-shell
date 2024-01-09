set -l commands install uninstall develop check init publish build clean run c cc js test doc doc2 refresh search

function __fish_nimble_installed_packages -a noVers
  for line in (nimble list -i)
    set -l name (string match -g -r "^(\w+)" $line)
    # Have option to uninstall everything
    echo "$name"
    # Also provide suggestions for each version
    if test -z "$noVers"
        for pkgVersion in (string match -a -g -r "version: (\S+)," $line)
          echo "$name@$pkgVersion"
        end
    end
  end
end

function __fish_nimble_available_packages
  string match -g -r "^(\w+)" (nimble list)
end

function __fish_nimble_bins
  string match -g -r "^bin: \"(.*)\"" (nimble dump) | string split ", "
end

complete -c nimble -f

# install
complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "install" -f -d "Installs a package"
complete -c nimble -n "__fish_seen_subcommand_from install" -s d -l depsOnly -d "Only install dependencies"
complete -c nimble -n "__fish_seen_subcommand_from install" -s p -l passNim -d "Forward specified flag to compiler"
complete -c nimble -n "__fish_seen_subcommand_from install" -l noRebuild -d "Don't rebuild binaries if they're up-to-date"
complete -c nimble -n "__fish_seen_subcommand_from install" -k -a "(__fish_nimble_available_packages)"

# develop
complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "develop" -f -d "Clones a package for development"
complete -c nimble -n "__fish_seen_subcommand_from develop" -l withDependencies -f -d "Also puts the dependencies into develop mode"
complete -c nimble -n "__fish_seen_subcommand_from develop" -s p -l path -x -d "Specifes the path where packages should be cloned"
complete -c nimble -n "__fish_seen_subcommand_from develop" -s a -l add -x -d "Add package at path into develop mode"
complete -c nimble -n "__fish_seen_subcommand_from develop" -s r -l removePath -x -d "Removes a path from develop mode"
complete -c nimble -n "__fish_seen_subcommand_from develop" -s n -l removeName -d "Removes a package from develop mode"
complete -c nimble -n "__fish_seen_subcommand_from develop" -s i -l include -d "Includes a develop file"
complete -c nimble -n "__fish_seen_subcommand_from develop" -s e -l exclude -d "Excludes a develop file"
complete -c nimble -n "__fish_seen_subcommand_from develop" -s g -l global -d "Create old style file link for developing"
complete -c nimble -n "__fish_seen_subcommand_from develop" -k -a "(__fish_nimble_available_packages)"
complete -c nimble -n "__fish_seen_subcommand_from develop" -k -a "(__fish_nimble_available_packages)"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "check" -f -d "Verifies the validity of current package"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "init" -d "Initialises a new Nimble project"
complete -c nimble -n "__fish_seen_subcommand_from init" -l git -d "Also initialise a git repo"
complete -c nimble -n "__fish_seen_subcommand_from init" -l hg -d "Also initialise a mercurial repo"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "publish" -f -d "Publish package to nim-lang/packages"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "uninstall" -d "Uninstall a package"
complete -c nimble -n "__fish_seen_subcommand_from uninstall" -k -a "(__fish_nimble_installed_packages)"
complete -c nimble -n "__fish_seen_subcommand_from uninstall" -s i -l inclDeps -d "Also uninstall dependencies"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "build" -d "Builds a package"
complete -c nimble -n "__fish_seen_subcommand_from build" -f -a "(__fish_nimble_bins)"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "clean" -d "Clean build artefacts"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "run" -d "Builds and runs a package"
complete -c nimble -n "__fish_seen_subcommand_from run" -f -a "(__fish_nimble_bins)"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "c cc js" -d "Builds a file inside package"
complete -c nimble -n "__fish_seen_subcommand_from c cc js" -k -F -r -a "(__fish_complete_suffix .nim)"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "test" -d "Compile and run tests"
complete -c nimble -n "__fish_seen_subcommand_from test" -s c -l continue -d "Don't stop execution on a failed test"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "doc doc2" -d "Builds documentation for a file inside a package"
complete -c nimble -n "__fish_seen_subcommand_from run doc doc2" -k -F -r -a "(__fish_complete_suffix .nim)"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "refresh" -d "Refreshes the package list"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "search" -d "Searches for a specified package"
complete -c nimble -n "__fish_seen_subcommand_from search" -l ver -d "Queries remote server for package version"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "list" -d "Lists all packages"
complete -c nimble -n "__fish_seen_subcommand_from list" -s i -l installed -d "Lists all installed packages"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "tasks" -d "Lists tasks in the nimble file"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a "path" -x -d "Shows absolute path to the installed packages"
complete -c nimble -n "__fish_seen_subcommand_from path" -k -a "(__fish_nimble_installed_packages --noVers)"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a dump -x -d "Dumps nimble package information"
complete -c nimble -n "__fish_seen_subcommand_from dump" -k -a "(__fish_nimble_installed_packages --noVers)"
complete -c nimble -n "__fish_seen_subcommand_from dump" -l ini -d "Output in ini format (default)"
complete -c nimble -n "__fish_seen_subcommand_from dump" -l json -d "Output in JSON format"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a lock -f -d "Generates/updates lock file"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a upgrade -x -d "Upgrades packages in the lock file"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a deps -d "Outputs the dependency tree"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a sync -d "Synchronises develop mode dependencies with lock file"
complete -c nimble -n "__fish_seen_subcommand_from dump" -s l -listOnly -d "Only lists the packages which are not synced"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a setup -d "Creates nimble.paths file to configure project"

complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a shell -d "Creates shell with PATH modified to include binary dependencies"
complete -c nimble -n "not __fish_seen_subcommand_from $commands" -a shellenv -d "Returns script which will modify PATH to include binary dependencies"

# Global options
complete -c nimble -n "__fish_use_subcommand" -s h -l help -d "Print help message"
complete -c nimble -n "__fish_use_subcommand" -s v -l version -d "Print version information"
complete -c nimble -n "__fish_use_subcommand" -s y -l accept -d "Accept all interactive prompts"
complete -c nimble -n "__fish_use_subcommand" -s n -l reject -d "Reject all interactive prompts"
complete -c nimble -n "__fish_use_subcommand" -s l -l localdeps -d "Run in local dependency mode"
complete -c nimble -n "__fish_use_subcommand" -s t -l package -d "Run command for a different package in the dependency tree"
complete -c nimble -n "__fish_use_subcommand" -s t -l tarballs -d "Enable downloading of packages as tarballs (Only works for GitHub packages)"
complete -c nimble -n "__fish_use_subcommand" -l nimbleDir -d "Set nimble directory"
complete -c nimble -n "__fish_use_subcommand" -l nim -d "Set Nim compiler binary"
complete -c nimble -n "__fish_use_subcommand" -l silent -d "Hide all Nimble and Nim output"
complete -c nimble -n "__fish_use_subcommand" -l verbose -d "Show all non-debug output"
complete -c nimble -n "__fish_use_subcommand" -l offline -d "Don't use network"
complete -c nimble -n "__fish_use_subcommand" -l noColor -d "Don't colorise output"
complete -c nimble -n "__fish_use_subcommand" -l noSslCheck -d "Don't check SSL certificates"
complete -c nimble -n "__fish_use_subcommand" -l noLockfile -d "Ignore the lock file if present"
complete -c nimble -n "__fish_use_subcommand" -l developFile -d "Specify which develop file to use"
complete -c nimble -n "__fish_use_subcommand" -l useSystemNim -d "Use system nim and ignore Nim from the lock file"
