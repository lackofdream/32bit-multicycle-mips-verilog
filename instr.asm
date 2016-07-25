.text
ori $t7, $zero, 0
main:
lbu $t0, 0xfffb($zero) # $t0: 当前状态
ori $t1, $zero, 0
beq $t0, $t1, wait_op
ori $t1, $zero, 1
beq $t0, $t1, wait_write_addr
ori $t1, $zero, 2
beq $t0, $t1, wait_read_addr
ori $t1, $zero, 3
beq $t0, $t1, wait_write_data
j wait_op

wait_write_data:
ori $t7, $zero, 3  # $t7 存储上一个非0状态
ori $t1, $zero, 0x0f   # 指示用，中间亮为等待写入数据
sb $t1, 0xfffd($zero)  # 指示用，中间亮为等待写入数据
ori $t1, $zero, 0xf0   # 指示用，中间亮为等待写入数据
sb $t1, 0xfffc($zero)  # 指示用，中间亮为等待写入数据
j main

wait_write_addr:
ori $t7, $zero, 1  # $t7 存储上一个非0状态
ori $t1, $zero, 0xf0   # 指示用，两边亮为等待RAM地址，用来写入数据
sb $t1, 0xfffd($zero)  # 指示用，两边亮为等待RAM地址，用来写入数据
ori $t1, $zero, 0x0f   # 指示用，两边亮为等待RAM地址，用来写入数据
sb $t1, 0xfffc($zero)  # 指示用，两边亮为等待RAM地址，用来写入数据
j main

wait_read_addr:
ori $t7, $zero, 2  # $t7 存储上一个非0状态
ori $t1, $zero, 0xff   # 指示用，全亮为等待RAM地址，用来读取数据
sb $t1, 0xfffd($zero)  # 指示用，全亮为等待RAM地址，用来读取数据
ori $t1, $zero, 0xff   # 指示用，全亮为等待RAM地址，用来读取数据
sb $t1, 0xfffc($zero)  # 指示用，全亮为等待RAM地址，用来读取数据
j main

wait_op:
ori $t1, $zero, 0
beq $t7, $t1, to_main   # 上一个状态为0
ori $t1, $zero, 1
beq $t7, $t1, get_write_addr  # 上一个非0状态为1
ori $t1, $zero, 2
beq $t7, $t1, get_read_addr  # 上一个非0状态为2
ori $t1, $zero, 3
beq $t7, $t1, get_write_data
j to_main

get_write_data:   # 上一个非0状态为3
lbu $t6, 0xfffe($zero) # 拨码开关低8位
lbu $t3, 0xffff($zero) # 拨码开关高8位
sll $t3, $t3, 8
or $t6, $t6, $t3 # $t6: 获取的写入数据
sw $t6, 0($t5)
ori $t7, $zero, 0
j main

to_main:
ori $t1, $zero, 0xaa   # 指示用，交替亮为等待操作，空闲状态
sb $t1, 0xfffd($zero) 
ori $t1, $zero, 0xaa 
sb $t1, 0xfffc($zero)
j main

get_write_addr:
lbu $t5, 0xfffe($zero) # 拨码开关低8位
lbu $t3, 0xffff($zero) # 拨码开关高8位
sll $t3, $t3, 8
or $t5, $t5, $t3 # $t5: 获取的写入地址
ori $t7, $zero, 0
j main


get_read_addr:
lbu $t4, 0xfffe($zero) # 拨码开关低8位
lbu $t3, 0xffff($zero) # 拨码开关高8位
sll $t3, $t3, 8
or $t4, $t4, $t3 # $t4: 获取的读取地址

lw $t3, 0($t4) # t3: 内存内容
sb $t3, 0xfffc($zero)
srl $t3, $t3, 8
sb $t3, 0xfffd($zero)

display_addr: # display data in $t0

li $t2, 0x4
judge:
beq $t2, 0, main
li $t3, 0x0000000f
and $t3, $t3, $t4
beq $t3, 0x0, _dis0
beq $t3, 0x1, _dis1
beq $t3, 0x2, _dis2
beq $t3, 0x3, _dis3
beq $t3, 0x4, _dis4
beq $t3, 0x5, _dis5
beq $t3, 0x6, _dis6
beq $t3, 0x7, _dis7
beq $t3, 0x8, _dis8
beq $t3, 0x9, _dis9
beq $t3, 0xa, _disa
beq $t3, 0xb, _disb
beq $t3, 0xc, _disc
beq $t3, 0xd, _disd
beq $t3, 0xe, _dise
beq $t3, 0xf, _disf
_dis0: li $t1, 0x03
j next
_dis1: li $t1, 0x9f
j next
_dis2: li $t1, 0x25
j next
_dis3: li $t1, 0x0d
j next
_dis4: li $t1, 0x99
j next
_dis5: li $t1, 0x49
j next
_dis6: li $t1, 0x41
j next
_dis7: li $t1, 0x1f
j next
_dis8: li $t1, 0x01
j next
_dis9: li $t1, 0x09
j next
_disa: li $t1, 0x11
j next
_disb: li $t1, 0xc1
j next
_disc: li $t1, 0x63
j next
_disd: li $t1, 0x85
j next
_dise: li $t1, 0x61
j next
_disf: li $t1, 0x71

next: 
sb $t1, 0xfff9($zero)
beq $t2, 0x4, first
beq $t2, 0x3, second
beq $t2, 0x2, third
beq $t2, 0x1, forth 
first:
li $t1, 0xe
sb $t1, 0xfffa($zero)
j final
second:
li $t1, 0xd
sb $t1, 0xfffa($zero)
j final
third:
li $t1, 0xb
sb $t1, 0xfffa($zero)
j final
forth:
li $t1, 0x7
sb $t1, 0xfffa($zero)
j final
final:
li $t1, 0xf
sb $t1, 0xfffa($zero)
srl $t4, $t4, 4
sub $t2, $t2, 1
j judge
