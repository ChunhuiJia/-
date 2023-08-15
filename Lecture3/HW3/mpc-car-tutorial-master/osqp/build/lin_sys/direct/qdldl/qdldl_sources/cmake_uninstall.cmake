if(NOT EXISTS "/media/jiachunhui/软件/BaiduNetdiskDownload/第三章约束优化/HW3_20220822_175717/HW3/mpc-car-tutorial-master/osqp/build/install_manifest.txt")
  message(FATAL_ERROR "Cannot find install manifest: /media/jiachunhui/软件/BaiduNetdiskDownload/第三章约束优化/HW3_20220822_175717/HW3/mpc-car-tutorial-master/osqp/build/install_manifest.txt")
endif(NOT EXISTS "/media/jiachunhui/软件/BaiduNetdiskDownload/第三章约束优化/HW3_20220822_175717/HW3/mpc-car-tutorial-master/osqp/build/install_manifest.txt")

file(READ "/media/jiachunhui/软件/BaiduNetdiskDownload/第三章约束优化/HW3_20220822_175717/HW3/mpc-car-tutorial-master/osqp/build/install_manifest.txt" files)
string(REGEX REPLACE "\n" ";" files "${files}")
foreach(file ${files})
  message(STATUS "Uninstalling $ENV{DESTDIR}${file}")
  if(IS_SYMLINK "$ENV{DESTDIR}${file}" OR EXISTS "$ENV{DESTDIR}${file}")
    exec_program(
      "/usr/bin/cmake" ARGS "-E remove \"$ENV{DESTDIR}${file}\""
      OUTPUT_VARIABLE rm_out
      RETURN_VALUE rm_retval
      )
    if(NOT "${rm_retval}" STREQUAL 0)
      message(FATAL_ERROR "Problem when removing $ENV{DESTDIR}${file}")
    endif(NOT "${rm_retval}" STREQUAL 0)
  else(IS_SYMLINK "$ENV{DESTDIR}${file}" OR EXISTS "$ENV{DESTDIR}${file}")
    message(STATUS "File $ENV{DESTDIR}${file} does not exist.")
  endif(IS_SYMLINK "$ENV{DESTDIR}${file}" OR EXISTS "$ENV{DESTDIR}${file}")
endforeach(file)
