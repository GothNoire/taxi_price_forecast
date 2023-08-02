import add_empty_schedule
from sys import argv


add_empty_schedule.add_empty_schedule(argv[1], argv[2], int(argv[3]))


with open("add_empty_schedule_log.txt", "a") as file:
    file.write(f'python3 add_empty_schedule.py \"{argv[1]}\" \"{argv[2]}\" \"{argv[3]}\"')
    file.write('\n')

