# Localization

helloSystem is localized on [Hosted Weblate](https://hosted.weblate.org/projects/hellosystem/).

<a href="https://hosted.weblate.org/engage/hellosystem/">
<img src="https://hosted.weblate.org/widgets/hellosystem/-/multi-auto.svg" alt="Translation status" />
</a>

## Contributing translations

helloSystem is translated into many languages by volunteers all over the world.

Translation happens on [Weblate](https://hosted.weblate.org/engage/hellosystem/). Everyone can contribute! Be sure to use the "Automatic suggestions" button which suggests translations from Deepl, Google Translate, Microsoft Translator, and various open source projects. This reduces the work to picking the most appropriate translation in many cases.

## Making strings available for translation

### Qt

Follow the best practices for internationalization of Qt projects. To be documented.

### Python

helloSystem uses `tstranslator.py` to translate applications using Qt `.ts` files without the need for compilation. To achieve this, import and set up tstranslator as follows:

```
# Translate this application using Qt .ts files without the need for compilation
import tstranslator
tstr = tstranslator.TsTranslator(os.path.dirname(__file__) + "/i18n", "")
def tr(input):
    return tstr.tr(input)
```

In the class that defines your MainWindow or Wizard, do the following:

```
class Wizard(QtWidgets.QWizard, object):
    def __init__(self):
        (...)
        # Translate the widgets in the UI objects in the Wizard
        self.setWindowTitle(tr(self.windowTitle()))
        for e in self.findChildren(QtCore.QObject, None, QtCore.Qt.FindChildrenRecursively):
            if hasattr(e, 'text') and hasattr(e, 'setText'):
                e.setText(tr(e.text()))
```

To make new strings available for translation, a developer runs in the respective application directory:

```
cd Resources/
mkdir -p i18n

# Create/update .ts file for English
pylupdate5 -noobsolete *.{py,ui} -ts i18n/en.ts

# Remove unneeded location tags
xml ed -L -d '//location' i18n/en.ts 

# Remove translations from en, since en is not to be further translated
xml ed -L -d '//translation' i18n/en.ts 
```

Translators do not need to do this.
