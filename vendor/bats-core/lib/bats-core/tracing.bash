#!/usr/bin/env bash

bats_capture_stack_trace() {
	local test_file
	local funcname
	local i

	# The last entry in the stack trace is not useful when en error occured:
	# It is either duplicated (kinda correct) or has wrong line number (Bash < 4.4)
	# Therefore we capture the stacktrace but use it only after the next debug
	# trap fired.
	# Expansion is required for empty arrays which otherwise error
	BATS_CURRENT_STACK_TRACE=("${BATS_STACK_TRACE[@]+"${BATS_STACK_TRACE[@]}"}")

	BATS_STACK_TRACE=()

	for ((i = 2; i != ${#FUNCNAME[@]}; ++i)); do
		# Use BATS_TEST_SOURCE if necessary to work around Bash < 4.4 bug whereby
		# calling an exported function erases the test file's BASH_SOURCE entry.
		test_file="${BASH_SOURCE[$i]:-$BATS_TEST_SOURCE}"
		funcname="${FUNCNAME[$i]}"
		BATS_STACK_TRACE+=("${BASH_LINENO[$((i - 1))]} $funcname $test_file")
		case "$funcname" in
		"$BATS_TEST_NAME" | setup | teardown | setup_file | teardown_file)
			break
			;;
		esac
		if [[ "${BASH_SOURCE[$i + 1]:-}" == *"bats-exec-file" ]] && [[ "$funcname" == 'source' ]]; then
			break
		fi
	done
}

bats_print_stack_trace() {
	local frame
	local index=1
	local count="${#@}"
	local filename
	local lineno

	for frame in "$@"; do
		bats_frame_filename "$frame" 'filename'
		bats_trim_filename "$filename" 'filename'
		bats_frame_lineno "$frame" 'lineno'

		if [[ $index -eq 1 ]]; then
			printf '# ('
		else
			printf '#  '
		fi

		local fn
		bats_frame_function "$frame" 'fn'
		if [[ "$fn" != "$BATS_TEST_NAME" ]] && 
			# don't print "from function `source'"",
			# when failing in free code during `source $test_file` from bats-exec-file
			! [[ "$fn" == 'source' &&  $index -eq $count ]]; then 
			printf "from function \`%s' " "$fn"
		fi

		if [[ $index -eq $count ]]; then
			printf 'in test file %s, line %d)\n' "$filename" "$lineno"
		else
			printf 'in file %s, line %d,\n' "$filename" "$lineno"
		fi

		((++index))
	done
}

bats_print_failed_command() {
	if [[ ${#BATS_STACK_TRACE[@]} -eq 0 ]]; then
		return 
	fi
	local frame="${BATS_STACK_TRACE[${#BATS_STACK_TRACE[@]} - 1]}"
	local filename
	local lineno
	local failed_line
	local failed_command

	bats_frame_filename "$frame" 'filename'
	bats_frame_lineno "$frame" 'lineno'
	bats_extract_line "$filename" "$lineno" 'failed_line'
	bats_strip_string "$failed_line" 'failed_command'
	printf '%s' "#   \`${failed_command}' "

	if [[ "$BATS_ERROR_STATUS" -eq 1 ]]; then
		printf 'failed%s\n' "$BATS_ERROR_SUFFIX"
	else
		printf 'failed with status %d%s\n' "$BATS_ERROR_STATUS" "$BATS_ERROR_SUFFIX"
	fi
}

bats_frame_lineno() {
	printf -v "$2" '%s' "${1%% *}"
}

bats_frame_function() {
	local __bff_function="${1#* }"
	printf -v "$2" '%s' "${__bff_function%% *}"
}

bats_frame_filename() {
	local __bff_filename="${1#* }"
	__bff_filename="${__bff_filename#* }"

	if [[ "$__bff_filename" == "$BATS_TEST_SOURCE" ]]; then
		__bff_filename="$BATS_TEST_FILENAME"
	fi
	printf -v "$2" '%s' "$__bff_filename"
}

bats_extract_line() {
	local __bats_extract_line_line
	local __bats_extract_line_index=0

	while IFS= read -r __bats_extract_line_line; do
		if [[ "$((++__bats_extract_line_index))" -eq "$2" ]]; then
			printf -v "$3" '%s' "${__bats_extract_line_line%$'\r'}"
			break
		fi
	done <"$1"
}

bats_strip_string() {
	[[ "$1" =~ ^[[:space:]]*(.*)[[:space:]]*$ ]]
	printf -v "$2" '%s' "${BASH_REMATCH[1]}"
}

bats_trim_filename() {
	printf -v "$2" '%s' "${1#$BATS_CWD/}"
}

# normalize a windows path from e.g. C:/directory to /c/directory
# The path must point to an existing/accessable directory, not a file!
bats_normalize_windows_dir_path() { # <output-var> <path>
	local output_var="$1"
	local path="$2"
	if [[ $path == ?:* ]]; then
		NORMALIZED_INPUT="$(cd "$path" || exit 1; pwd)"
	else
		NORMALIZED_INPUT="$path"
	fi
	printf -v "$output_var" "%s" "$NORMALIZED_INPUT"
}

bats_emit_trace() {
	if [[ $BATS_TRACE_LEVEL -gt 0 ]]; then
		local line=${BASH_LINENO[1]}
		# shellcheck disable=SC2016
		if [[ $BASH_COMMAND != '"$BATS_TEST_NAME" >> "$BATS_OUT" 2>&1 4>&1' && $BASH_COMMAND != "bats_test_begin "* ]] && # don't emit these internal calls
			[[ $BASH_COMMAND != "$BATS_LAST_BASH_COMMAND" || $line != "$BATS_LAST_BASH_LINENO" ]] &&
			# avoid printing a function twice (at call site and at definiton site)
			[[ $BASH_COMMAND != "$BATS_LAST_BASH_COMMAND" || ${BASH_LINENO[2]} != "$BATS_LAST_BASH_LINENO" || ${BASH_SOURCE[3]} != "$BATS_LAST_BASH_SOURCE" ]]; then
			local file="${BASH_SOURCE[2]}" # index 2: skip over bats_emit_trace and bats_debug_trap
			if [[ $file == "${BATS_TEST_SOURCE}" ]]; then
				file="$BATS_TEST_FILENAME"
			fi
			local padding='$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
			if (( BATS_LAST_STACK_DEPTH != ${#BASH_LINENO[@]} )); then
				printf '%s [%s:%d]\n' "${padding::${#BASH_LINENO[@]}-4}" "${file##*/}" "$line" >&4
			fi
			printf '%s %s\n'  "${padding::${#BASH_LINENO[@]}-4}" "$BASH_COMMAND"  >&4
			BATS_LAST_BASH_COMMAND="$BASH_COMMAND"
			BATS_LAST_BASH_LINENO="$line"
			BATS_LAST_BASH_SOURCE="${BASH_SOURCE[2]}"
			BATS_LAST_STACK_DEPTH="${#BASH_LINENO[@]}"
		fi
	fi
}

bats_debug_trap() {
	# on windows we sometimes get a mix of paths (when install via nmp install -g)
	# which have C:/... or /c/... comparing them is going to be problematic.
	# We need to normalize them to a common format!
	local NORMALIZED_INPUT
	bats_normalize_windows_dir_path NORMALIZED_INPUT "${1%/*}"
	local file_excluded='' path
	for path in "${_BATS_DEBUG_EXCLUDE_PATHS[@]}"; do
		if [[ "$NORMALIZED_INPUT" == "$path"* ]]; then
			file_excluded=1
			break
		fi
	done
	
	# don't update the trace within library functions or we get backtraces from inside traps
	# also don't record new stack traces while handling interruptions, to avoid overriding the interrupted command
	if [[ -z "$file_excluded" && "${BATS_INTERRUPTED-NOTSET}" == NOTSET ]]; then
		bats_capture_stack_trace
		bats_emit_trace
	fi
}

# For some versions of Bash, the `ERR` trap may not always fire for every
# command failure, but the `EXIT` trap will. Also, some command failures may not
# set `$?` properly. See #72 and #81 for details.
#
# For this reason, we call `bats_error_trap` at the very beginning of
# `bats_teardown_trap` (the `DEBUG` trap for the call will fix the stack trace)
# and check the value of `$BATS_TEST_COMPLETED` before taking other actions.
# We also adjust the exit status value if needed.
#
# See `bats_exit_trap` for an additional EXIT error handling case when `$?`
# isn't set properly during `teardown()` errors.
bats_error_trap() {
	local status="$?"
	if [[ -z "$BATS_TEST_COMPLETED" ]]; then
		BATS_ERROR_STATUS="${BATS_ERROR_STATUS:-$status}"
		if [[ "$BATS_ERROR_STATUS" -eq 0 ]]; then
			BATS_ERROR_STATUS=1
		fi
		BATS_STACK_TRACE=("${BATS_CURRENT_STACK_TRACE[@]}")
		trap - DEBUG
	fi
}

bats_add_debug_exclude_path() { # <path>
	if [[ -z "$1" ]]; then # don't exclude everything
		printf "bats_add_debug_exclude_path: Exclude path must not be empty!\n" >&2
		return 1
	fi
	if [[ "$OSTYPE" == cygwin || "$OSTYPE" == msys ]]; then
		bats_normalize_windows_dir_path normalized_dir "$1"
		_BATS_DEBUG_EXCLUDE_PATHS+=("$normalized_dir")
	else
		_BATS_DEBUG_EXCLUDE_PATHS+=("$1")
	fi
}

bats_setup_tracing() {
	_BATS_DEBUG_EXCLUDE_PATHS=()
	# exclude some paths by default
	bats_add_debug_exclude_path "$BATS_ROOT/lib/"
	bats_add_debug_exclude_path "$BATS_ROOT/libexec/"


	exec 4<&1 # used for tracing
	if [[ "${BATS_TRACE_LEVEL:-0}" -gt 0 ]]; then
		# avoid undefined variable errors
		BATS_LAST_BASH_COMMAND=
		BATS_LAST_BASH_LINENO=
		BATS_LAST_BASH_SOURCE=
		BATS_LAST_STACK_DEPTH=
		# try to exclude helper libraries if found, this is only relevant for tracing
		while read -r path; do
			bats_add_debug_exclude_path "$path"
		done < <(find "$PWD" -type d -name bats-assert -o -name bats-support)
	fi

	# exclude user defined libraries
	IFS=':' read -r exclude_paths <<< "${BATS_DEBUG_EXCLUDE_PATHS:-}"
	for path in "${exclude_paths[@]}"; do
		if [[ -n "$path" ]]; then
			bats_add_debug_exclude_path "$path"
		fi
	done

	# turn on traps after setting excludedes to avoid tracing the exclude setup
	trap 'bats_debug_trap "$BASH_SOURCE"' DEBUG
  	trap 'bats_error_trap' ERR
}