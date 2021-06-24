/*
 * Copyright (C) 2015-2020 Alibaba Group Holding Limited
 */

#include "aos/init.h"
#include "board.h"
#include <aos/errno.h>
#include <aos/kernel.h>
#include <k_api.h>
#include <stdio.h>
#include <stdlib.h>

#include "py_engine_example.h"

int application_start(int argc, char *argv[])
{
    handle_identity_cmd(argc, argv);
    return 0;
}
