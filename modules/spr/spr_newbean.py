#!/usr/bin/env python
import sys
import re
beanClass = sys.argv[1]
m = re.search('\.(\w*$)', beanClass)
decapitalize = lambda s: s[:1].lower() + s[1:] if s else ''
beanName = decapitalize(m.group(1))
beanDef = '<ban name="' + beanName + '" class="' + beanClass + '" />'
aliasDef = '<alias name="' + beanName + '" alias="' + beanName + '" />'
print(aliasDef + "\n" + beanDef)
# usage: python test.py org.Test | xclip -selection clipboard
